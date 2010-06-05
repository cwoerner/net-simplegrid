package Net::SimpleGrid::Slave;

use strict;
use warnings;

use Socket;
use Text::CSV_XS;
use File::Spec;
use IO::Handle;
use POSIX ":sys_wait_h";
use Sys::Hostname qw/hostname/;

sub new {
    my ($class, %args) = @_;

    $class = ref $class || $class;

    $args{grid_manager} || die "missing GridManager in constructor";
    $args{task_class} || die "Missing task class in constructor";

    my $self = { 
	silent_mode => ($args{silent_mode} ? 1 : 0),
	grid_manager => $args{grid_manager},
	task_class => $args{task_class},
	task_args => $args{task_args},
	max_workers => 0,
	port => undef,
	workers => [],
	worker_pids => {},
    };

    bless $self, $class;

    $self->port($args{port} || 1337);
    $self->maxWorkers($args{max_workers} || 5);
    $self->sampleRate($args{sample_rate} || 15);

    return $self;
}

sub gridManager { return $_[0]->{grid_manager}; }

sub port { 
    my ($self, $p) = @_;
    
    if (defined $p) {
	sprintf("%d", $p) eq $p or die "invalid port '$p'";
	$self->{port} = $p;
    }

    return $self->{port};
}

sub sampleRate {
    my ($self, $s) = @_;
    
    if (defined $s) { 
	sprintf("%d", $s) eq $s or die "invalid sample rate '$s'";
	$self->{sample_rate} = $s;
    }

    return $self->{sample_rate};
}

sub maxWorkers { 
    my ($self, $w) = @_;
    
    if (defined $w) {
	sprintf("%d", $w) eq $w or die "invalid max workers '$w'";
	$self->{max_workers} = $w;
    }

    return $self->{max_workers};
}

sub workers {
    return @{$_[0]->{workers}};
}

sub addWorker {
    my ($self, $w) = @_;

    $self->{worker_pids}{$w->pid} = push(@{$self->{workers}}, $w) -1;
}

sub getWorkerByIndex {
    my ($self, $idx) = @_;
    if ($idx > $#{$self->{workers}}) { die "worker index out of bounds: $idx is too high ($#{$self->{workers}})"; }
    return $self->{workers}[$idx];
}

sub silentMode { return $_[0]->{silent_mode}; }

sub node {
    my ($self, $n) = @_;

    if ($n) {
	UNIVERSAL::isa($n, "Net::SimpleGrid::Node") or die "invalid node '$n'";
	$self->{node} = $n;
    }

    return $self->{node};
}

sub init {
    my ($self) = @_;

    # prefork
    while ($self->workers < $self->maxWorkers && $self->spawn) {}

    my $sigset = POSIX::SigSet->new();
    my $sigintact = POSIX::SigAction->new(sub { if (!$self->silentMode) { print STDERR "caught INT signal, cleaning up node...\n"; }; $self->shutdown(); exit },
				      $sigset, &POSIX::SA_NODEFER);
    POSIX::sigaction(&POSIX::SIGINT, $sigintact);	

    my $grid_manager = $self->gridManager;
    my $node = $grid_manager->findNode(hostname(), $self->port);

    if ($node) {
	if (!$node->isDisabled) { 
	    if (!$self->silentMode) { print STDERR "error starting node, there already exists a node entry for '" . $node->asUri . "' which is '" . $node->state . "'\n"; }
	    exit;
	}
    } else {
	$node = $grid_manager->registerNode(hostname(), $self->port, $self->maxWorkers);
    }

    $node->listen;
    $self->node($node);
}

sub run {
    my ($self) = @_;

    # 
    # advertise our readiness on the grid!
    #

    my $grid_manager = $self->gridManager;
    my $node = $self->node || die "invalid state: must call init() before trying to run()";
    my $read_sock = $node->readSocket;

    $grid_manager->enableNode($node);

    #
    # Listen for work to do and distribute work to the children
    #

    my $paddr;

    while ($paddr = accept(REQUEST, $read_sock)) { 
	last unless $self->handleRequest(\*REQUEST, $paddr);
    }

    $grid_manager->disableNode($node);
    $grid_manager->shutdownNode($node);
}

sub _isAdminCmd {
    my $cmd = pop;
    return $cmd =~ /^:/;
}

sub handleRequest {
    my ($self, $request, $paddr) = @_;

    my ($port, $iaddr) = sockaddr_in($paddr);
    my $name = gethostbyaddr($iaddr, AF_INET);
	
    #print STDERR "node '" . $node->asUri . "' got request from $name [" . inet_ntoa($iaddr) . "]\n";

    my $k = time;
    my $i = 0;
    my $written = 0;
    my $j;
    my $l;
    
    my $silent_mode      = $self->silentMode;
    my $node             = $self->node;
    my $grid_manager     = $self->gridManager;
    my @workers          = $self->workers;
    my $max_workers      = $self->maxWorkers;
    my $sample_rate_secs = $self->sampleRate;

    my $done = 0;

    while (my $line = <$request>) {

	if (!$grid_manager->handleAdminCmd($self, $line)) { 

	    if (!$self->processSchedulerStrategy->schedule($self, $line)) { 
		if (!$silent_mode) { print STDERR "node [$$] all children are dead.  they appear to be dead.  exiting...\n"; }
		$self->shutdown;
	    }
	}
	
	if (!$silent_mode && ($k - time > $sample_rate_secs)) { 
	    if (!$silent_mode) { print STDERR "node [$$] update for $sample_rate_secs sec time slice: " . ($i / (($k - time) + 1)) . " cmd/sec\n"; }
	    $k = time;
	}
    }
    
    close REQUEST;
    
    return $self->isDone;
}

sub processSchedulerStrategy { 
    my ($self) = shift;

    if (@_) {
	my $strat = shift;
	if (!$self->silentMode) { print STDERR "node [$$] configuring scheduler strategy as '$strat'\n"; }
	if (!ref($strat)) { 
	    eval "use $strat; 1;" or die "failed to create scheduler strategy '$strat': $@";
	    $strat = $strat->new;
	}

	UNIVERSAL::isa($strat, 'Net::SimpleGrid::ProcessScheduler') || die "invalid process scheduler strategy '$strat'";

	$self->{scheduler_strategy} = $strat;
    }

    if (!$self->{scheduler_strategy}) { 
	$self->{scheduler_strategy} = Net::SimpleGrid::ProcessScheduler::RoundRobinStrategy->new;
    }

    return $self->{scheduler_strategy};
}

sub isDone { 
    my ($self) = shift;

    if (@_) { 
	$self->{is_done} = $_[0] ? 1 : 0;
    }

    return $self->{is_done};
}

sub createTask {
    my ($self) = @_;
    
    my $task_clazz = $self->{task_class};
    my $args = $self->{task_args};
    my $task = $task_clazz->new($task_clazz->parse_opts($args));
    $task->prepare();
    return $task;
}

sub spawn {
    my ($self) = @_;

    # establish ipc mechanism

    socketpair(my $child, my $parent, AF_UNIX, SOCK_STREAM, PF_UNSPEC) || 
	die "failed to create socket pair: $!";
    $child->autoflush(1);
    $parent->autoflush(1);

    if (my $pid = fork()) {
	# parent
	close $parent;
        $self->addWorker(Net::SimpleGrid::Slave::Worker->new(
			     pid => $pid, 
			     reader => $child,
			     writer => $parent,
			 ) );
	return 1;

    } elsif (defined $pid) { 
	# worker child
	close $child;
	close STDIN;

	my $csv = Text::CSV_XS->new({binary => 1});

	my $task = $self->createTask();

	if (!$self->silentMode) { print STDERR "child start [$$]\n"; }

	my $sigset = POSIX::SigSet->new;
	my $sighupact = POSIX::SigAction->new(sub{ if (!$self->silentMode) { print STDERR "child [$$] ignoring HUP signal\n" } },
					      $sigset, &POSIX::SA_NODEFER);
	POSIX::sigaction(&POSIX::SIGHUP, $sighupact);

	while ($_ = <$parent>) {

	    eval {
		$csv->parse($_);
		$task->handle([$csv->fields]);
	    }; 
	    if ($@ && !$self->silentMode) { 
		print STDERR "child [$$] error in line $_: $@\n";
	    }
	}

	$task->onComplete();

	exit;

    } else {
	warn ("can't fork any more children (" . $self->workers . "): $!") unless $self->silentMode;
	return;
    }
}


sub shutdown {
    my ($self) = @_;

    if ($self->node && $self->gridManager) { 
	if (!$self->silentMode) { print STDERR "node disable '" . $self->node->asUri . "' at " . localtime() . "\n"; }
	$self->gridManager->disableNode($self->node);
    }

    if (!$self->silentMode) { print STDERR "node '" . $self->node->asUri . "' closing down " . localtime() . "\n"; }

    # this shuts them down immediately
    foreach my $worker ($self->workers) { 
	close $worker->getReaderSocket;
    }

    while (keys %{$self->{worker_pids}}) { 
	my $kid = waitpid(-1, WNOHANG);
	if ($kid > 0) { 
	    my $idx = delete $self->{worker_pids}{$kid};
	    eval { 
		# close again just in case we f'd up
		close $self->getWorker($idx)->getWriterSocket;
		close $self->getWorker($idx)->getReaderSocket;
	    };
	}
    }
}


1;

package Net::SimpleGrid::Slave::Worker;

sub new {
    my ($class, %args) = @_;
    $class = ref($class) || $class;

    return bless {%args}, $class;
}

sub pid { return $_[0]->{pid}; }
sub getReaderSocket { return $_[0]->{reader}; }
sub getWriterSocket { return $_[0]->{writer}; }

sub acceptWork { 
    my ($self, $data) = @_;

    print { $self->getReaderSocket } $data;
}

1;
