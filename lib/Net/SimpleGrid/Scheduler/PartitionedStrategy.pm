package Net::SimpleGrid::Scheduler::PartitionedStrategy;

use strict;
use warnings;
use Net::SimpleGrid::ProcessScheduler::PartitionedStrategy;

use base 'Net::SimpleGrid::Scheduler';

sub new {
    my ($class) = @_;
    $class = ref($class) || $class;
    
    my $self = bless {}, $class;
    $self->{nodes} = undef;
    
    return $self;
}

sub computeHash {
    my ($self, $id, $data) = @_;

    # hash the data to a node in {nodes}

	#
	# this is such a simple hashing strategy and I'm sure it doesn't produce anywhere near uniform distribution
	# but it's simple enough for our requirements:
	#
	#    1) the same string must hash to the same bucket
	#    2) all strings must be hashed into a valid bucket
	#    3) the hash value should depend on all bytes of the input string
	#    4) reasonable distribution (ie. no one child should get more than 2/N of the work)
	#


    my $hash = 0;
    my @chars = split "", $data;
    for (my $i = 0; $i < @chars; $i++) {
	$hash += ord($chars[$i]);
    }

    return $hash;
}

sub schedule {
    my ($self, $manager, $id, $data) = @_;
    
    if (!$self->{nodes}) { 
	$self->{nodes} = $manager->reserveNodes($id, $manager->maxReserve($id));
    }

    my $hash = $self->computeHash($id, $data);
    
    # encode the hash value as the first 10 characters in the data record and send the data to the node
    # this makes sure the child node uses the same value that we computed when bucketing it into the 
    # worker hash buckets

    $manager->sendDataToNode(sprintf("%-10s%s", $hash, $data), 
			     $self->{nodes}[($hash % ($#{$self->{nodes}} + 1))] );
}

sub getProcessScheduler {
    return "Net::SimpleGrid::ProcessScheduler::PartitionedStrategy";
}

1;
