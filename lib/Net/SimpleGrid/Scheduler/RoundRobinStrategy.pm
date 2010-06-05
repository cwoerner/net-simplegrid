package Net::SimpleGrid::Scheduler::RoundRobinStrategy;

use strict;
use warnings;

use Net::SimpleGrid::ProcessScheduler::RoundRobinStrategy;

use base 'Net::SimpleGrid::Scheduler';

sub new {
    my ($class) = @_;
    $class = ref($class) || $class;
    
    my $self = bless {}, $class;
    $self->{last_check_time} = 0;
    $self->{balancer_idx} = 0;
    $self->{nodes_map} = {};

    return $self;
}

sub schedule {
    my ($self, $manager, $id, $data) = @_;
    
    my @nodes;
    if (time - $self->{last_check_time} > 60) {
	print STDERR "scheduler [$$] checking for more nodes to allocate\n";
	$self->{last_check_time} = time;
	
	my $max = $manager->maxReserve($id);
	if (scalar(@nodes) < $max) {
	    @nodes = $manager->reserveNodes($id, ($max - scalar(@nodes)));
	    $self->{nodes_map}{$id} = \@nodes;
	}
    } else {
	@nodes = @{$self->{nodes_map}{$id}};
    }
    
    if ($self->{balancer_idx} > $#nodes) { 
	$self->{balancer_idx} = 0;
    }
    
    my $j = $self->{balancer_idx};
    
    #
    # select a socket
    #

    my $node;
    while (!$node) {
	$node = $nodes[$self->{balancer_idx}];
	
	if ($node->isInvalid) { 
	    
	    warn("skipping invalid node $self->{balancer_idx}\n");
	    
	    $node = undef;
	    
	    if ($j == $self->{balancer_idx}) { 
		die "cycled through all nodes and all are invalidated";
	    }
	}
	
	$self->{balancer_idx} = ($self->{balancer_idx} == $#nodes) ? 0 : $self->{balancer_idx} + 1;
    }

    $manager->sendDataToNode($data, $node);
}

sub getProcessScheduler {
    return "Net::SimpleGrid::ProcessScheduler::RoundRobinStrategy";
}

1;
