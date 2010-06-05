package Net::SimpleGrid::Writer;

use strict;
use warnings;

sub new { 
    my ($class, %opts) = @_;
    $class = ref($class) || $class;

    my $self = bless {}, $class;

    while (my ($k, $v) = each %opts) { 
	if ($self->UNIVERSAL::can($k)) {
	    $self->$k($v);
	}
    }

    return $self;
}

sub parse_opts {
    my ($class, $opts) = @_;

    ref($opts) eq 'ARRAY' || die "invalid argument, expected ARRAY ref";

    my %opts;
    foreach my $opt ( @$opts ) {
	my ($key, $val) = $opt =~ /(.*?)=(.*)/;
	$opts{$key} = $val;
    }

    return %opts;
}

sub write { die "method not implemented"; }
sub clone { return $_[0]->new; }
sub harvest {}

1;
