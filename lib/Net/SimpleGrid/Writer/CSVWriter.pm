package Net::SimpleGrid::Writer::CSVWriter;

use strict;
use warnings;

use Text::CSV_XS;
use base 'Net::SimpleGrid::Writer';

sub new { 
    my ($class, %opts) = @_;
    $class = ref($class) || $class;

    my $self = $class->SUPER::new(%opts);

    bless $self, $class;

    return $self;
}

sub writer_dir { 
    my ($self) = shift;

    if (my $arg = shift) { 
	$self->{writer_dir} = $arg;
    }

    $self->{writer_dir} ||= "./output";

    if (!-d $self->{writer_dir}) { 
	mkdir($self->{writer_dir}) || die "failed to create outputdir '$self->{writer_dir}': $!"; 
    }

    return $self->{writer_dir};
}


sub clone {
    my $proto = $_[0]->new; 
    $proto->csv($_[0]->csv); 
    return $proto; 
}

sub csv { 
    my ($self) = shift;
    
    if ($_[0]) { 
       $self->{csv} = shift;
    }

    if (!defined $self->{csv}) { 
       $self->{csv} = Text::CSV_XS->new({binary => 1});
    }

    return $self->{csv};
}

sub write { 
    # duns, url, company_description
    my ($self, $args) = @_;
    
    my $file = File::Spec->catfile($self->writer_dir, $args->[0]);
    $self->csv->combine(@$args);
    open (OUTFILE, ">", $file) || die "failed to open outfile '$file': $!";
    print OUTFILE $self->csv->string(), "\n";
    close OUTFILE;

    return 1;
}

use constant TAR => "tar";
use constant SCP => "scp";

sub harvest {
    my ($self, $scp_to) = @_;

    use Sys::Hostname;
    my $dir = $self->writer_dir;
    my $hostname = Sys::Hostname::hostname();
    $hostname =~ s|[/~\\]||g;

    my $tarball = sprintf("output-%s-%s-%s.tar.gz", time, $hostname, $$);
    (system(TAR, "-cvzf",$tarball, $dir) == 0) 
	|| die "failed to harvest data in dir '$dir': $!";

    (system(SCP, $tarball, $scp_to) == 0)
	|| die "failed to scp data back to $scp_to";
}

1;
