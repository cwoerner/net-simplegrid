package Net::SimpleGrid;

use strict;
use warnings;

our $VERSION = 0.09;

=head1 NAME

Net::SimpleGrid - Perl extension for Net grid system

=head1 SYNOPSIS

    bin/run-slave.sh Net::SimpleGrid::Task::CompanyDescriptionTask

    bin/run-master.sh 

=head1 DESCRIPTION

Grid system which allows massively concurrent processing of tasks.

=head1 SEE ALSO

Net::SimpleGrid::Manager, Net::SimpleGrid::States, Net::SimpleGrid::Task, Net::SimpleGrid::Writer, slave.pl, master.pl

=head1 AUTHOR

Charles Woerner, E<lt>charleswoerner@gmail.comE<gt>

=cut

1;
