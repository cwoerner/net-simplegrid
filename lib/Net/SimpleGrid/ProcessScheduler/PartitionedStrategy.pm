package Net::SimpleGrid::ProcessScheduler::PartitionedStrategy;

use strict;
use warnings;

use base 'Net::SimpleGrid::ProcessScheduler';

sub new {
    my ($class) = @_;
    $class = ref($class) || $class;
    
    my $self = bless {}, $class;
    
    return $self;
}

sub schedule {
    my ($self, $slave, $data) = @_;

    #
    # master must compute a numeric representation of the data somehow
    # and encode it in the data using this format:
    #   %-10s...data...
    #

    # chop off the first 10 chars which should hold the encoded hash value
    my $hash = substr($data, 0, 10, "");

    if (!$hash) { 
	die "child [$$] can't determine which node to hash data to! ($data)";
    }

    my $written = 0;
    while (!$written) { 
	eval { 
	    print { $slave->getWorkerByIndex($hash % scalar($slave->workers))->getReaderSocket } $data;
	    $written = 1;
	};
	if ($@) { 
	    if (!$slave->silentMode) { print STDERR "node [$$] failed to write to pipe (hash=$hash): $@\n"; }
	}
    }

    return $written;
}

1;

__DATA__
# hashing algorithm is

