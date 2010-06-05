#!/usr/bin/perl

=head1 NAME 

node-manager.pl - admin tool to manage grid slave nodes

=head1 SYNOPSIS

perl -Ilib bin/node-manager.pl \
    --hostname cwoerner.local \
    --port 1337 \
    --manager_args=dsn=dbi:mysql:<mydbname>... \
    --manager_args=username=<mydbuser> \
    --manager_args=password=<mydbpwd>  \
    <enable | disable | release | shutdown>

=cut

use Net::SimpleGrid::Manager;
use strict;
use warnings;

use Getopt::Long;

if ($ARGV[-1] =~ /^-/ || $ARGV[-2] =~ /^-[^\-]/) { 
	die "missing command!\nusage: $0 -h <hostname> -p <port> <enable|disable|release|shutdown>\n";
}
my $cmd = pop @ARGV;
my ($hostname, $port, @mgr_opts);
GetOptions("h|hostname=s" => \$hostname, "p|port=s" => \$port, "manager_args=s" => \@mgr_opts);

$cmd = lc($cmd);

my $grid_manager = Net::SimpleGrid::Manager->new(Net::SimpleGrid::Manager->parse_opts(\@mgr_opts));
my $node = $grid_manager->findNode($hostname, $port);
if (!$node) { 
    die "node '$hostname' '$port' does not exist!";
}

for ($cmd) { 
 
    /enable/ && do {
	$grid_manager->enableNode($node);
	last;
    };

    /disable/ && do {
	$grid_manager->disableNode($node);
	last;
    };

    /release/ && do {
	$grid_manager->enableNode($node);
	last;
    };

    /shutdown/ && do {
	my $id = $grid_manager->createReservationID();
	$grid_manager->connectToNode($id, $node, 1) || die "failed to connect to node";
	my $cmd = $grid_manager->createCommand('done', 1);
	$grid_manager->sendDataToNode($cmd, $node);
	last;
    };

}

exit;
