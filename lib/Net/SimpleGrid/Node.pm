package Net::SimpleGrid::Node;

=head1 NAME 

Net::SimpleGrid::Node - Object representing a node in the grid.

=head1 SYNOPSIS

 my $node = Net::SimpleGrid::Node->new;
 $node->hostname("foo.com");
 $node->port(1234);
 $node->state(Net::SimpleGrid::States::DISABLED());
 $node->startTime(time);
 $node->children(2);
 $node->reservedBy($resv_id);

 print $node->asUri;
 if ($node->isReservedBy($resv_id)) { print "this node is reserved by '$resv_id'"; }
 elsif ($node->isReserved) { print "this node is reserved by someone"; }

 if ($node->isEnabled) { print "this node is enabled"; }
 elsif ($node->isActive) { print "this node is active"; }
 elsif ($node->isInvalid) { print "this node is invalid"; }
 elsif ($node->isDisabled) { print "this node is disabled"; }

=head1 DESCRIPTION

Object representing a node in the grid.  This is just a container for data - setting these properties will have little or no effect on the actual running instance of the server.  For instance, setting the port() property of a Node object does not change what port the server is running on.  A Node represents a grid node and when persisted using the Grid::Manager::updateNode() method it will affect how this node advertises it's services to the grid, but changing properties of the Node object will have the effect of reconfiguring the server.

=head1 METHODS

=cut

use strict;
use warnings;
use Socket;
use Net::SimpleGrid::States;


=head2 new

Create a new node object.

=cut

sub new { 
    my ($class, %args) = @_;
    $class = ref($class) || $class;

    return bless {%args}, $class;
}

=head2 asUri

String identifier of the node.

=cut

sub asUri {
    if (@_ == 1) { 
	return "tcp://".$_[0]->hostname . ":" . $_[0]->port;
    } else {
	return "tcp://".$_[1] . ":" . $_[2];
    }
}


=head2 hostname

Gets/sets the hostname for this node.  Does not affect the actual server.

=cut

sub hostname { 
    my ($self, $h) = @_;

    if (defined($h)) { 
	$self->{hostname} = $h;
    }

    return $self->{hostname};
}

=head2 port

Gets/sets the port number for this node.  Does not affect the actual server.

=cut

sub port {
    my ($self, $p) = @_;
    
    if (defined($p)) {
	die "expected numeric value, not '$p'" unless $p == sprintf("%d", $p);
	$self->{port} = $p;
    }

    return $self->{port};
}

=head2 state

Gets/sets the state of the node.

=cut

sub state {
    my ($self, $s) = @_;

    if (defined($s)) { 
	$self->{state} = $s;
    }
    
    return $self->{state};
}

=head2 startTime

Gets/sets the startTime for this node.

=cut

sub startTime {
    my ($self, $t) = @_;

    if (defined($t)) { 
	die "expected numeric value, not '$t'" unless $t == sprintf("%d", $t);
	$self->{start_time} = $t;
    }

    return $self->{start_time};
}

=head2 children

Gets/sets the number of children available on this node.

=cut

sub children {
    my ($self, $c) = @_;

    if (defined($c)) { 
	die "expected numeric value, not '$c'" unless $c == sprintf("%d", $c);
	$self->{children} = $c;
    }

    return $self->{children};
}

=head2 reservedBy

Gets/sets the reservation id.

=cut

sub reservedBy {
    my ($self, $r) = @_;
    
    if (defined($r)) { 
	$self->{reserved_by} = $r;
    }

    return $self->{reserved_by};
}

=head2 isEnabled

=head2 isActive

=head2 isDisabled

=head2 isInvalid

=head2 isReserved

Utility methods to determine whether the Node is registered with the grid in a particular state.

=cut

sub isEnabled {
    return $_[0]->state eq Net::SimpleGrid::States::ENABLED(); 
}

sub isActive {
    return $_[0]->isEnabled || ($_[0]->state eq Net::SimpleGrid::States::CLEANUP());
}

sub isDisabled {
    return $_[0]->state eq Net::SimpleGrid::States::DISABLED();
}

sub isInvalid {
    return $_[0]->state eq Net::SimpleGrid::States::INVALID();
}

sub isReserved {
    return $_[0]->state eq Net::SimpleGrid::States::RESERVED();
}

=head2 isReservedBy

Determine whether the node is reserved by a particular reservation id.

=cut

sub isReservedBy {
    my ($self, $id) = @_;

    return $self->isReserved && ($self->reservedBy eq $id);
}

=head2 listen

Initiates the server socket of a slave node.  Sets readSocket().

=cut

sub listen {
    my($node) = @_;
    
    #
    # create a network socket channel on which we will listen for work to do
    #
    my $port = $node->port;
    my $proto = getprotobyname('tcp');
    socket(my $data, PF_INET, SOCK_STREAM, $proto) || die "failed to create tcp socket: $!";
    setsockopt($data, SOL_SOCKET, SO_REUSEADDR, pack('l', 1)) || die "failed to set reuseaddr property on socket: $!";
    bind($data, sockaddr_in($port, INADDR_ANY)) || die "failed to bind to port '$port': $!";
    CORE::listen($data, SOMAXCONN) || die "failed to listen on port '$port': $!";

    print STDERR "node start [$$] on port $port \@ " . localtime() . "\n";

    return $node->readSocket($data);
}

=head2 readSocket

Gets/sets the socket on which we listen for work.

=cut

sub readSocket {
    my ($self) = shift;

    if (@_ > 0) {
	$self->{read_socket} = shift;
    }

    return $self->{read_socket};
}

=head2 connect

Connect to a remote node so that we can send it data.  Sets writeSocket().

=cut

sub connect {
    my ($node) = @_;

    my $iaddr = inet_aton($node->hostname) || die "no host '".$node->hostname."': $!";
    my $paddr = sockaddr_in($node->port, $iaddr);
    my $proto = getprotobyname('tcp');
    socket(my $sock, PF_INET, SOCK_STREAM, $proto)  || die "socket: $!";
    $sock->autoflush(1);
    CORE::connect($sock, $paddr)    || die "connect: $!";
    
    return $node->writeSocket($sock);
}

=head2 writeSocket

Gets/sets the socket on which we can write work for the node to do.

=cut

sub writeSocket {
    my ($self) = shift;

    if (@_ > 0) {
	$self->{write_socket} = shift;
    }

    return $self->{write_socket};
}

1;

=head1 AUTHOR

Charles Woerner E<lt>charleswoerner@gmail.comE<gt>, 2008-02-15

=cut

