package Net::SimpleGrid::ProcessScheduler::RoundRobinStrategy;

use strict;
use warnings;

use base 'Net::SimpleGrid::ProcessScheduler';

sub new {
    my ($class) = @_;
    $class = ref($class) || $class;

    my $self = $class->SUPER::new();

    $self->{rr_counter} = 0;

    return bless $self, $class;
}

sub schedule {
    my ($self, $slave, $data) = @_;
	    
    my $written = 0;
    my $j = $self->{rr_counter};
    my $num_workers = scalar $slave->workers;

    while (!$written) { 
	eval {	    
	    $slave->getWorkerByIndex($self->{rr_counter}++ % $num_workers)->acceptWork($data);
	    $written = 1;
	}; 
	if ($@) { 
	    if (!$slave->silentMode) { print STDERR "node [$$] failed to write to pipe (rr_counter=$self->{rr_counter}): $@\n"; }
	}
	
	last if $j == $self->{rr_counter};
    }
    
    return $written;
}

1;
