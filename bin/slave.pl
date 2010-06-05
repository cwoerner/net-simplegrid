#!/usr/bin/perl

=head1 NAME

slave.pl - grid node worker for company description append system

=head1 SYNOPSIS

 perl -Ilib bin/slave.pl -p 1337 -m 2 \ 
  --manager_arg='dsn=dbi:mysql:database=<mydbname>;host=localhost;port=3306' \ 
  --manager_arg='username=<mydbuser>'  \ 
  --manager_arg='password=<mydbpwd>' \ 
  --manager_arg=domain=local  \ 
  -t Net::SimpleGrid::Task::CompanyDescriptionTask

=head1 OPTIONS

The following command line options are available

=over 4

    -p|--port          The port we want to listen on
    -m|--max_workers   Number of worker processes to spawn on this machine
    -t|--task_class    Net::SimpleGrid::Task subclass implementing the actual work
    --task_arg         name=value pair of options to pass to task_class constructor
    --manager_arg      name=value pair of options to pass to Grid::Manager constructor

=back

=head1 EXAMPLES

The manager_arg property is passed on to the Grid::Manager constructor as well as the Task impl class.  If you build
your task to use a database then just create properties called dsn, username and password and you will be able
to use the same login creds as the Grid::Manager.  See the Net::SimpleGrid::Task::CompanyDescriptionTask as an example.

Run a slave which will perform a task using 100 preforked children using the default database:

=over 4

bin/run-slave.sh Net::SimpleGrid::Task::MyExampleTask -m 100

=back

Run a slave which will perform a task using 5 preforked children using a separate database:

=over 4

bin/run-slave.sh Net::SimpleGrid::Task::MyTask -m 5 --manager_arg='dsn=dbi:mysql:database=mydb;hostname=localhost;port=3306' --manager_arg=username=dba --manager_arg=password=xxx

=back
 
Sometimes you may need to specify the domain that the server is on (for instance, when the master doesn't have a default search domain defined in /etc/resolv.conf).  Here is how you would run a task that advertised itself as being available on `hostname`.compute-1.local:

=over 4

bin/run-slave.sh Net::SimpleGrid::Task::MyTask --manager_arg=domain=compute-1.local

=back

Run a slave which will listen on port 1338 (the default is 1337):

=over 4

bin/run-slave.sh Net::SimpleGrid::Task::MyTask -p 1338

=back

Where relative paths are concerned the system assumes that the system is executing in the /opt/simple-grid directory.  If this is not the case (ie. you are running from your svn workspace) then use the GRID_MGR_HOME environment variable to root the system elsewhere:

=over 4

GRID_MGR_HOME=. ./bin/run-slave.sh Net::SimpleGrid::Task::MyTask -m 5 ...

=back

Lastly, the database server address is obtained from the $GRID_MGR_HOME/conf/server.addr config file.  This value can be overridden using the SADDR environment variable:

=over 4

SADDR=localhost ./bin/run-slave.sh Net::SimpleGrid::Task::MyTask -m 5 --manager_arg=domain=local ...

=back

=head1 AUTHOR

Charles Woerner E<lt>charleswoerner@gmail.comE<gt>

=cut

use strict;
use warnings;

use Text::CSV_XS;
use Getopt::Long;
use Net::SimpleGrid::Manager;
use Net::SimpleGrid::Slave;

my $port;
my $task_clazz;
my $max_workers;
my @task_args;
my @manager_args;
my $silent_mode;
my $sample_rate_secs;

GetOptions(
    "p|port=i" => \$port,
    "t|task_class=s" => \$task_clazz,
    "m|max_workers=i" => \$max_workers,
    "task_arg=s" => \@task_args,
    "manager_arg=s" => \@manager_args,
    "q|quiet" => \$silent_mode,
    "s|sample_rate_secs=i" => \$sample_rate_secs,
    );

$task_clazz ||= "Net::SimpleGrid::Task::CompanyDescriptionTask";
eval "use $task_clazz; 1;" or die "failed to import task class '$task_clazz': $@";
$sample_rate_secs = 60 unless $sample_rate_secs > 0;

my $grid_manager = Net::SimpleGrid::Manager->new(Net::SimpleGrid::Manager->parse_opts(\@manager_args));
my $slave = Net::SimpleGrid::Slave->new(
    grid_manager => $grid_manager, 
    max_workers => $max_workers, 
    silent_mode => $silent_mode, 
    task_class => $task_clazz, 
    port => $port, 
    task_args => [@manager_args, @task_args], 
    sample_rate => $sample_rate_secs
    );

$slave->init;
$slave->run;
$slave->shutdown;



exit;

