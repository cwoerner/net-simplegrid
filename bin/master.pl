#!/usr/bin/perl

=head1 NAME

bin/master.pl - management node for the Net task grid system

=head1 SYNOPSIS

bin/master.pl --manager_arg='dsn=dbi:mysql:<mydbname>@somehost:3306' \
    --manager_arg='username=<mydbuser>' \
    --manager_arg='password=<mydbpwd>'  \
    --manager_arg='scheduler=Net::SimpleGrid::Scheduler::PartitionedStrategy::ByEmailDomain' \
    --shutdown_slaves \
    --max_reserve=10

=head1 OPTIONS

=over 4

Command line options available:

    manager_arg       Arguments to pass to the Grid::Manager constructor
    m|max_reserve     The maximum number of slaves to reserve, default is 20
    s|shutdown_slaves Whether or not to shutdown the 
    i|init_slave_cmd  Name/value pair representing a command that the slave will interpret as a special administrative command.  Will be sent before any data is sent.

=back

=head1 EXAMPLES

The out-of-the-box master node that comes with this system (you are free to write your own) attempts to allocate up to 20 slaves and will not shutdown the slave nodes when all data has been sent.

Run a master that allocates the default number of nodes and then exists, leaving the slaves up:

=over 4

cat /path/to/mydatafile | bin/run-master.sh

=back

Run a master that allocates only 5 slaves in the grid:

=over 4

cat /path/to/mydatafile | bin/run-master.sh -m 5

=back

Run a master that allocates 100 slaves in the grid and tells them to shutdown when processing is complete:

=over 4

cat /path/to/mydatafile | bin/run-master.sh -m 100 --shutdown_slaves

=back

The GRID_MGR_HOME environment variable applies to the master scripts as well as the slave scripts:

=over 4

cat /path/to/mydatafile | GRID_MGR_HOME=. ./bin/run-master.sh -m 100

=back

=head1 AUTHOR

Charles Woerner E<lt>charleswoerner@gmail.comE<gt>, 2008-02-14

=cut

use strict;
use warnings;

use Getopt::Long;
use File::Spec;
use URI;
use IO::Handle;
use POSIX ":sys_wait_h";
use Net::SimpleGrid::Manager;


print STDERR "master [$$] starting at " . localtime() . "\n";

my @manager_args;
my $max_reserve;
my $shutdown_slaves;
my @init_slave_cmd;

GetOptions(
    "manager_arg=s" => \@manager_args,
    "m|max_reserve=i" => \$max_reserve,
    "s|shutdown_slaves" => \$shutdown_slaves,
    "i|init_slave_cmd=s" => \@init_slave_cmd,
    );

$max_reserve ||= 20;

my $grid_manager = Net::SimpleGrid::Manager->new(Net::SimpleGrid::Manager->parse_opts(\@manager_args));
my $id = $grid_manager->createReservationID();

END {
    if ($grid_manager && $id) { 
	$grid_manager->releaseNodes($id);
    }
}

my $sigset = POSIX::SigSet->new();
my $sigintact = POSIX::SigAction->new(sub {print STDERR "master [$$] caught INT signal, releasing nodes...\n"; exit },
				      $sigset, &POSIX::SA_NODEFER);
POSIX::sigaction(&POSIX::SIGINT, $sigintact);	

$grid_manager->maxReserve($id, $max_reserve);
print STDERR "master [$$] id '$id' reserving $max_reserve slaves\n";

if (@init_slave_cmd) {
    foreach my $init_slave_cmd (@init_slave_cmd) { 
	my ($cmd, $val) = split '=', $init_slave_cmd, 2;
	$grid_manager->cmdOnSocketInit(sub { $_[0]->sendDataToNode($_[0]->createCommand($cmd, $val), $_[1]) });
    }
}

if ($shutdown_slaves) { 
    $grid_manager->cmdOnSocketCleanup(sub { $_[0]->sendDataToNode($_[0]->createCommand('done', 1), $_[1]) });
}

if (($grid_manager->reserveNodes($id))[0]) { 

    print STDERR "master [$$] reading stdin for data\n";

    my $line;
    while ($line = <STDIN>) {
	$grid_manager->schedule($id, $line);
    }
}

print STDERR "master [$$] done at " . localtime() . "\n";
exit;

