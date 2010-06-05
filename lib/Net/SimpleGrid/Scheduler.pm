package Net::SimpleGrid::Scheduler;

sub schedule { die "schedule must be implemented by base class"; }
sub getProcessScheduler { die "getProcessScheduler must be implemented by base class"; }

1;
