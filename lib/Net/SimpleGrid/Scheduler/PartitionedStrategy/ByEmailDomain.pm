package Net::SimpleGrid::Scheduler::PartitionedStrategy::ByEmailDomain;

use strict;
use warnings;
use Text::CSV_XS;

use base 'Net::SimpleGrid::Scheduler::PartitionedStrategy';

sub new { 
    my ($class) = @_;
    $class = ref $class || $class;

    my $self = $class->SUPER::new();
    bless $self, $class;

    return $self;
}


{
    my $csv = Text::CSV_XS->new({binary => 1});
    sub computeHash {
	my ($self, $id, $data) = @_;
	
	$csv->parse($data);
	my @fields = $csv->fields;

	my ($domain) = ($fields[0] =~ /.*?\@([a-z0-9A-Z_\-.]+\.(?:com|net|org|edi|mil|gov|int|biz|info|name|pro|aero|coop|museum))/);
	$domain = join ".", (split (/\./, $domain))[-2 .. -1];
	
	return $self->SUPER::computeHash($id, $domain);
    }
}



1;
