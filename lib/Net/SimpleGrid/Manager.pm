package Net::SimpleGrid::Manager;

=head1 NAME

Net::SimpleGrid::Manager - Interacts with the node database and manages communication between server and nodes in the grid.

=head1 SYNOPSIS

 # create and setup the manager
 my $mgr = Net::SimpleGrid::Manager->new;
 $mgr->dsn("dbi:mysql:${mydbname};hostname=localhost;port=3306");
 $mgr->username($mydbuser);
 $mgr->password($mydbpwd);

 $mgr->scheduler("Net::SimpleGrid::Scheduler::RoundRobinStrategy");
 # or..
 $mgr->scheduler(Net::SimpleGrid::Scheduler::RoundRobinStrategy->new);

 # create an id for this session
 my $resv_id  = $mgr->createReservationID();

 # set a limit to the number of nodes that should be reserved in the grid
 $mgr->maxReserve(100);
 
 # reserve some nodes
 my @nodes_reserved = $mgr->reserveNodes($id);

 die "no nodes reserved!" unless @nodes_reserved;

 # let the manager load balance for you and dynamically add new nodes 
 $mgr->schedule($resv_id, "a,task");

 # schedule it yourself on one of the known reserved nodes
 $mgr->schedule($resv_id, "a,task", $nodes_reserved[0]);

 # cleanup when you're done
 $mgr->releaseNodes($resv_id); 

=head1 DESCRIPTION

Management object that encapsulates all the complexities of the grid system.

=head1 METHODS

=cut

use strict;
use warnings;
use Sys::Hostname;
use URI;
use DBI;
use Socket;
use IO::Handle;

use Net::SimpleGrid::Node;
use Net::SimpleGrid::States;
use Net::SimpleGrid::Scheduler::RoundRobinStrategy;

=head2 new

Create a new instance of the Grid::Manager.

=cut

sub new {
    my ($class, %args) = @_;
    $class = ref($class) || $class;

    my $self = bless {}, $class;
    $self->{node_list} = [];
    $self->{on_sock_init} = [];
    $self->{on_sock_cleanup} = [];

    while (my ($k, $v) = each %args) { 
	if (UNIVERSAL::can($self, $k)) { 
	    $self->$k($v);
	}
    }

    return $self;
}

=head2 parse_opts

Parser manager_arg cmd line arguments into a hash list.

=cut

sub parse_opts {
    my ($class, $opts) = @_;

    ref($opts) eq 'ARRAY' || die "invalid argument, expected ARRAY ref";

    my %opts;
    foreach my $opt ( @$opts ) {
	my ($key, $val) = $opt =~ /(.*?)=(.*)/;
	$opts{$key} = $val;
    }

    return %opts;
}

=head2 dbh

Gets/sets the database handle.

=cut


sub dbh { 
    my ($self) = shift;

    if (@_) { 
	$self->{dbh} = shift;
    } else { 

	if (!$self->{dbh}) { 
	    
	    my ($err);
	    
	    for (my $i = 0; $i < 5 && !$self->{dbh}; $i++) { 
		undef $err;
		$self->{dbh} = DBI->connect($self->dsn, $self->username, $self->password) || do {
		    $err = $DBI::errstr;
		    warn "child [$$] db connection " . $self->username . "\@" . $self->dsn . ", sleeping before trying again: $err\n";
		    sleep(2);
		};
	    }
	    
	    if (!$self->{dbh}) { 
		die "child [$$] failed to connect to db: $err\n";
	    }
	}
    }

    return $self->{dbh};
}

=head2 dsn

=head2 username

=head2 password

Gets/sets the corresponding database connection properties.

=cut

sub dsn { @_ > 1 && ($_[0]->{dsn} = $_[1]); $_[0]->{dsn}; }
sub username { @_ > 1 && ($_[0]->{username} = $_[1]); $_[0]->{username}; }
sub password { @_ > 1 && ($_[0]->{password} = $_[1]); $_[0]->{password}; }

=head2 scheduler 

Gets/sets the Net::SimpleGrid::Scheduler implementation.  Defaults to RoundRobinStrategy.

=cut

sub scheduler {
    my ($self, $strat) = @_;

    if ($strat) { 
	if (!ref $strat) { 
	    $strat =~ /^Net::SimpleGrid::Scheduler::/ or die "$strat does not appear to be a Scheduler class";
	    eval("use $strat; 1;") or die "failed to import scheduler class '$strat': $@";
	    $strat = $strat->new;
	}
	UNIVERSAL::isa($strat, "Net::SimpleGrid::Scheduler") || die "invalid scheduler '$strat'";
	$self->{scheduler} = $strat;
    }

    if (!$self->{scheduler}) { 
	$self->{scheduler} = Net::SimpleGrid::Scheduler::RoundRobinStrategy->new;
    }

    return $self->{scheduler};
}

=head2 schedule

Schedule work to be distributed to a node reserved by the corresponding reservation id.

=cut

sub schedule {
    my ($self, $id, $data, $node) = @_;
    
    if (!$node) { 
	$self->scheduler->schedule($self, $id, $data);
    } else {
	$self->sendDataToNode($data, $node);
    }
}

=head2 sendDataToNode 

Sends some work for execution on a node.

=cut

sub sendDataToNode {
    my ($self, $data, $node) = @_;

    if (my $sock = $node->writeSocket) { 
	print $sock $data;
    } else {
	die "you must connect to a node before sending it work!";
    }
}

=head2 handleAdminCmd

=cut

sub handleAdminCmd {
    my ($self, $slave, $line) = @_;

    if ($line =~ /^:(.*?)=(.*)$/) {
	my ($cmd, $value) = ($1, $2);

	print STDERR "slave [$$] handle admin command '$cmd'='$value'\n";

      SWITCH:
	for (lc($cmd)) { 
	    /^done$/ && do {
		$value = 0 if $value =~ /no/i;
		$value = 1 if $value =~ /yes/i;
		$slave->isDone($value);
		last SWITCH;
	    };

	    # :scheduler=Net::SimpleGrid::ProcessScheduler::SomeStrategy
	    # :scheduler.myProperty=somevalue
	    /^scheduler(?:\.(.*))?$/ && do {
		if ($1) { 
		    my $prop = $1;
		    if (UNIVERSAL::can($slave->processSchedulerStrategy, $prop)) { 
			$slave->processSchedulerStrategy->$prop($value);
		    } else {
			warn("invalid process scheduler property '$prop' value '$value'");
		    }
		} else {
		    $slave->processSchedulerStrategy($value); # it's a process scheduler class
		}

		last SWITCH;
	    };

	    # fall-through
	    do {
		print STDERR "unknown admin command '$cmd' with value '$value', ignoring\n";
		last SWITCH;
	    };
	}

	return 1;
    }

    return 0;
}

=head2 cmdOnSocketInit

Gets/sets the CODE reference to run when a socket connection to a node is initialized.  Runs
after socket connection is created.  Code reference is invoked with the socket and node 
references passed in as the argument list.

=cut

sub cmdOnSocketInit {
    my ($self, $closure) = @_;
    
    if ($closure) {
	ref($closure) eq 'CODE' or die "invalid code block '$closure'";
	$self->{on_sock_init} ||= [];
	push @{$self->{on_sock_init}}, $closure;
    }

    return wantarray ? @{$self->{on_sock_init}} : $self->{on_sock_init};
}

=head2 cmdOnSocketCleanup

Gets/sets the CODE reference to run when a socket connection to a node is cleaned up.  
Runs before socket close().  Code reference is invoked with the socket and node references 
passed in as the argument list.

=cut

sub cmdOnSocketCleanup {
    my ($self, $closure) = @_;
    
    if ($closure) {
	ref($closure) eq 'CODE' or die "invalid code block '$closure'";
	$self->{on_sock_cleanup} ||= [];
	push @{$self->{on_sock_cleanup}}, $closure;
    }

    return wantarray ? @{$self->{on_sock_cleanup}} : $self->{on_sock_cleanup};
}

=head2 createCommand

Creates an administrative command to be sent to a slave.  Valid commands are:

=over

=item done

Tells the slave to shutdown.  Value is 1.

=item scpto

Tells the slave where to scp information to (if applicable). Value is in the form username@host:dir

=back

=cut

sub createCommand {
    my ($self, $cmd, $val) = @_;
    return sprintf(":%s=%s\n", $cmd, $val);
}

=head2 domain

Gets/sets the domain append value used with qualifyHostname().

=cut

sub domain {
    my ($self, $d) = @_;
    
    if (defined($d)) {
	$self->{append_domain} = $d;
    }

    return $self->{append_domain} || "";
}

=head2 qualifyHostname

Fully qualify a hostname using the optional domain property.

=cut

sub qualifyHostname {
    my ($self, $hostname) = @_;

    return $self->domain ? sprintf("%s.%s", $hostname, $self->domain) : $hostname;
}

=head2 connectToNode

Make a socket connection to a node in the grid so that you can give it work.

=cut

sub connectToNode {
    my ($self, $id, $node, $no_invalidate_on_fail) = @_;

    if (!$node->writeSocket) { 
	
	eval { 
	    
	    #
	    # create a connection to the remote host
	    #

	    my $sock = $node->connect; 

	    # configure the node for this type of scheduling strategy
	    # for instance, if we want to use a "sticky" strategy then the stickiness must be
	    #    maintained when the slave schedules data on a child process
	    $self->sendDataToNode($self->createCommand('scheduler', $self->scheduler->getProcessScheduler()), $node);
	    
	    if (my $codes = $self->cmdOnSocketInit()) {
		foreach my $code (@$codes) { 
		    $code->($self, $node);
		}
	    }
	};
	if ($@) { 
	    warn "failed to create socket for host '" . $node->asUri . "', skipping: $@";
	    $node->writeSocket(undef);
	    $node->state(Net::SimpleGrid::States::INVALID());
	    $self->updateNode($node) unless $no_invalidate_on_fail;
	    return;
	}
    }

    return 1;
}

=head2 reserveNodes

Negative value will cause us to reserve everything greedily.

=cut

sub reserveNodes {
    my ($self, $id, $i) = @_;

    $i = $self->maxReserve($id) unless defined($i);

    if ($i != sprintf("%d", $i)) { 
	die "invalid argument, expected numeric value, not '$i'";
    }

    my @enabled_nodes = $self->findEnabledNodes();

    my $node;
    while ($i != 0 && @enabled_nodes) {
	eval {
	    $node = shift(@enabled_nodes);
	    $self->connectToNode($id, $node);
	    if (!$node->isInvalid) { 
		$self->reserveNode($node, $id) && $i--;
	    }
	};
	if ($@) { 
	    print STDERR "failed to connect and reserve node '" . $node->asUri . "': $@";
	}
    }

    return $self->findReservedNodes($id);
}


sub SELECT_NODES_SQL { "select hostname, port, children, start_time, state, reserved_by from nodes "; }


=head2 findNode

Returns the node identified by hostname and port.

=cut

sub findNode {
    my ($self, $hostname, $port) = @_;

    return ($self->findNodes("where hostname = ? and port = ?", [$self->qualifyHostname($hostname), $port], 1))[0];
}

=head2 findNodesByState

Returns a list of nodes matching the state.

=cut

sub findNodesByState {
    my ($self, $state) = @_;

    return ($self->findNodes("where state = ? order by start_time", [$state]));
}

=head2 findNodes

Generic finder that taks a predicate clause and returns the results from the nodes table matching that criteria.

=cut

sub findNodes {
    my ($self, $predicate, $args, $max) = @_;

    my @results = ();
    my $iter = $self->dbh->selectall_arrayref(SELECT_NODES_SQL() . $predicate, undef, @$args);

    $max ||= scalar(@$iter);
    if (sprintf("%d", $max) ne $max) { 
	die "invalid max criteria '$max'";
    }

    foreach my $rs (@$iter) {
	last if ($max-- <= 0);
	push @results, $self->_loadNode($rs);
    }

    return wantarray ? @results : \@results;
}

{
    my %nodemap = ();
    sub _loadNode {
	my ($self, $cols) = @_;
	
	my $node = $nodemap{Net::SimpleGrid::Node->asUri($cols->[0], $cols->[1])};
	if (!$node) { 
	    $node = Net::SimpleGrid::Node->new();
	    $node->hostname($cols->[0]);
	    $node->port($cols->[1]);
	    $node->children($cols->[2]);
	    $node->startTime($cols->[3]);
	    $node->state($cols->[4]);
	    $node->reservedBy($cols->[5]);
	    $nodemap{$node->asUri} = $node;
	}

	return $node;
    }
};

=head2 findEnabledNodes 

Returns a list of nodes that are eligible to do work.

=cut

sub findEnabledNodes {
    my ($self) = @_;
    print STDERR "finding enabled nodes\n";
    return $self->findNodesByState(Net::SimpleGrid::States::ENABLED());
}

use constant RESERVE_ALL => -1;

=head2

Get/set the maximum number of nodes to reserve a given reservation id.

=cut

sub maxReserve {
    my ($self, $id, $m) = @_;

    if (!defined($id)) { 
        die "missing reservation id in maxReserve";
    }

    if (defined($m)) {
	die "expected a numeric value, not '$m'" unless $m == sprintf("%d", $m);

	$self->{max_reserve}{$id} = $m;
    }

    return $self->{max_reserve}{$id} || RESERVE_ALL;
}

=head2 createReservationID

Create a new reservation id.

=cut

sub createReservationID {
    return sprintf("pid %s euid %s host %s", $$, $>, $_[0]->qualifyHostname(Sys::Hostname::hostname()) );
}

=head2 releaseNodes

Release all nodes associated with a reservation id.

=cut

sub releaseNodes {
    my ($self, $id) = @_;

    foreach my $node ($self->findReservedNodes($id)) { 

	# close the socket connection
	eval { 
	    my $sock = $node->writeSocket;
	    eval { 
		print STDERR "admin server [$$] releasing node '" . $node->asUri . "'\n";

		if (my $codes = $self->cmdOnSocketCleanup()) { 
		    foreach my $cmd (@$codes) { 
			$cmd->($self, $node);
		    }
		}

		$node->writeSocket(undef);
	    };
	};
	if ($@) { 
	    print STDERR "admin server [$$] failed to release socket from node '" . $node->asUri . "': $@\n";
	}

	# make it available again
	eval { $self->enableNode($node); };
	if ($@) { 
	    print STDERR "failed to enable node '" . $node->asUri . "': $@\n";
	}
    }

}

=head2 findReservedNodes

Returns a list of nodes reserved under the given reservation id.

=cut

sub findReservedNodes {
    my ($self, $id) = @_;

    print STDERR "finding reserved nodes for $id\n";
    my @results = ();
    foreach my $node ($self->findNodesByState(Net::SimpleGrid::States::RESERVED())) {
	print STDERR "found node reserved by " . $node->reservedBy . "\n";
	next unless $node->isReservedBy($id);
	
	push @results, $node;
    }

    return wantarray ? @results : \@results;
}

=head2 registerNode

Registers the nodes in the grid table.  If the node already exists in the nodes table then it will 
just be returned as-is.  Otherwise, a new entry in the nodes table will be created for this node 
with the visibility of DISABLED.

=cut

sub registerNode {
    my ($self, $hostname, $port, $children) = @_;
    
    my $node = $self->findNode($hostname, $port);
    if (defined($node)) {
	warn "attempt to register enabled node '" . $node->asUri . "'";
    } else {
	$node = Net::SimpleGrid::Node->new(hostname => $self->qualifyHostname($hostname), port => $port, children => $children);
	$self->insertNode($node);
    }

    return $node;
}

=head2 insertNode

Inserts a new node into the nodes table.

=cut

sub insertNode {
    my ($self, $node) = @_;

    $self->dbh->do("insert into nodes (hostname, port, reserved_by, children, state) values (?, ?, '', ?, ?)", undef, 
		   $node->hostname, $node->port, $node->children, Net::SimpleGrid::States::DISABLED() ) || die "failed to insert node '" . $node->asUri . "': " . $self->dbh->errstr;
}

=head2 reserveNode

Reserve a node for a producer so that no other producers can use it.

=cut

sub reserveNode {
    my ($self, $node, $id) = @_;

    $node->state(Net::SimpleGrid::States::RESERVED());
    $node->reservedBy($id);
    return $self->dbh->do("update nodes set children = ?, start_time = ?, state = ?, reserved_by = ? where hostname = ? and port = ? and state = ?", undef, $node->children, $node->startTime, $node->state, $node->reservedBy, $node->hostname, $node->port, Net::SimpleGrid::States::ENABLED());
}

=head2 disableNode

Makes the node unavailable for any more requests from the server's perspective.

=cut

sub disableNode {
    my ($self, $node) = @_;

    $node->state(Net::SimpleGrid::States::DISABLED());
    $node->reservedBy("");
    return $self->updateNode($node);
}

=head2 shutdownNode
    
Destroys the socket.

=cut

sub shutdownNode {
    my ($self, $node) = @_;

    my $sock = $node->readSocket;
    
    close $sock;

    $node->readSocket(undef);
}
=head2 enableNode

Makes the node visible to the server.

=cut

sub enableNode {
    my ($self, $node) = @_;

    $node->state(Net::SimpleGrid::States::ENABLED());
    $node->startTime(time);
    $node->reservedBy("");

    return $self->updateNode($node);
}

=head2 unregisterNode

Deletes a node from the nodes table.

=cut

sub unregisterNode {
    my ($self, $node) = @_;

    return $self->dbh->do("delete from nodes where hostname = ? and port = ? and state <> ?", undef, $node->hostname, $node->port, Net::SimpleGrid::States::RESERVED());
}

=head2 updateNode

Update the node in the db.

=cut

sub updateNode {
    my ($self, $node) = @_;

    return $self->dbh->do("update nodes set children = ?, start_time = ?, state = ?, reserved_by = ? where hostname = ? and port = ?", undef, $node->children, $node->startTime, $node->state, $node->reservedBy, $node->hostname, $node->port);
}

1;

=head1 AUTHOR

Charles Woerner E<lt>charleswoerner@gmail.comE<gt>, 2008-02-15

=cut

