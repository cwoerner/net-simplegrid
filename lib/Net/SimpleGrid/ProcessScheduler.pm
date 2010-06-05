package Net::SimpleGrid::ProcessScheduler;

use strict;
use warnings;

sub new {
    my ($class) = @_;
    $class = ref($class) || $class;

    return bless {}, $class;
}

sub schedule {
    die "schedule() must be implemented in subclass";
}

1;
