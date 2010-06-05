package Net::SimpleGrid::Task;

use strict;
use warnings;

sub new { 
    my ($class, %opts) = @_;
    $class = ref($class) || $class;

    my $self = bless {
	data => [],
    }, $class;

    while (my ($k, $v) = each %opts) { 
	if (UNIVERSAL::can($self, $k)) {
	    $self->$k($v);
	}
    }

    $self->reset;

    return $self;
}

sub prepare {}

sub addData {
    my ($self) = shift;
    
    push @{$self->{data}}, @_;
}

sub getData { 
    my ($self, $i) = @_;
    if (defined($i)) { 
	return $self->{data}[$i];
    } else {
	return wantarray ? @{$self->{data}} : $self->{data};
    }
}

sub count { return scalar(@{$_[0]->{data}}); }

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

sub writer {
    my ($self, $writer) = @_;

    if ($writer) { 
	UNIVERSAL::isa($writer, 'Net::SimpleGrid::Writer') || die "expected a Net::SimpleGrid::Writer, got a '$writer'";
	$self->{writer} = $writer;
    }

    return $self->{writer};
}

sub handle { 
    my $self = shift;
    
    $self->reset;
    $self->doTask(@_);
}

sub reset {
    $_[0]->clearData;
}

sub clearData { $_[0]->{data} = []; }

sub doTask {
    die "Method doTask not implemented";
}

sub onComplete {}

1;
