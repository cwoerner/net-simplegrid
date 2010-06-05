package Net::SimpleGrid::Task::CompanyDescriptionTask;

=head1 NAME

Net::SimpleGrid::Task::CompanyDescriptionTask - grid task to retrieve company description information from website meta tags

=head1 SYNOPSIS

 my $task = Net::SimpleGrid::Task::CompanyDescriptionTask->new(dsn => 'dbi:mysql:...', username => 'xxx', password => 'xxx');
 $task->handle([$acme_co_duns_number, $acme_co_url]);

=head1 DESCRIPTION

Our feed providers don't give us company description information for all the companies in our database.  When possible, 
we want to supplement that information with the text associated with that company's website's meta "description" tag.

=head1 DATABASE

This task expects to be configured with a dsn(), username(), and password().  It expects the dsn() to point to a database
which contains a table called "domain_description" in the following form:

    mysql> describe domain_description
    +-------------+-------------+------+-----+---------+-------+
    | Field       | Type        | Null | Key | Default | Extra |
    +-------------+-------------+------+-----+---------+-------+
    | domain      | varchar(50) | YES  |     | NULL    |       |
    | description | text        | YES  |     | NULL    |       |
    +-------------+-------------+------+-----+---------+-------+

=head1 METHODS

=cut

use strict;
use warnings;
use URI;
use HTTP::Request;
use LWP::UserAgent;
use Net::SimpleGrid::Writer::DBWriter;

use base 'Net::SimpleGrid::Task';

sub new { 
    my ($class, %opts) = @_;
    $class = ref($class) || $class;

    my $self = $class->SUPER::new(%opts);
    bless $self, $class;

    if (!($self->dsn && $self->username && $self->password)) { 
	die "missing dsn, username or password in CompanyDescriptionTask constructor!";
    }

    $self->writer(Net::SimpleGrid::Writer::DBWriter->new);
    $self->writer->dsn($self->dsn);
    $self->writer->username($self->username);
    $self->writer->password($self->password);
    $self->writer->sql("insert into domain_description (domain, description) values (?, ?)");

    return $self;
}

sub prepare {
    my ($self) = @_;

    my $dbh = $self->writer->dbh;
    
    $dbh->do("describe domain_description") ||
	$dbh->do("create table domain_description (domain varchar(50), description text)") ||
	die "failed to create table domain_description: " . $dbh->errstr;
}

sub dsn { @_ > 1 && ($_[0]->{dsn} = $_[1]); $_[0]->{dsn}; }
sub username { @_ > 1 && ($_[0]->{username} = $_[1]); $_[0]->{username}; }
sub password { @_ > 1 && ($_[0]->{password} = $_[1]); $_[0]->{password}; }


sub userAgent {
    my ($self) = @_;

    $self->{user_agent} ||= LWP::UserAgent->new("Net/0.1");

    return $self->{user_agent};
}

sub parser {
    my ($self) = @_;

    $self->{parser} ||= HTML::Parser->new(
	start_h => [sub { $self->parse_start(@_) }, "tagname,attr,text"],
	report_tags => [qw/meta/]
	);

    return $self->{parser};
}

sub doTask {
    my ($self, $fields) = @_;

    my ($url) = @$fields;

    my $orig_url = $url;
    if ($url !~ m|^https?://|) { 
	$url = sprintf("http://%s", $url);
    }

    $url = URI->new($url);
    my $req = HTTP::Request->new(GET => $url);
    my $response = $self->userAgent->request($req);
    if ($response->is_success) { 
	my $cont = $response->content;
	$self->parser->parse($cont);
	$self->writer->write([$orig_url, $self->getData(0)]);
    } else {
	; # noop
    }
}


sub parse_start { 
    my ($self, $tagname, $attr, $text) = @_;
    if ($tagname eq 'meta') { $self->parse_meta($tagname, $attr, $text); }
}

sub parse_meta {
    my ($self, $tagname, $attr, $text) = @_;
    if (exists($attr->{name}) && defined($attr->{name}) && $attr->{name} eq 'description') { 
	my $desc = $attr->{content};
	$desc =~ s/[\r\n]/ /g;
	$self->addData($desc);
    }
}

1;

__END__

=head1 AUTHOR

Charles Woerner E<lt>charleswoerner@gmail.comE<gt>, 2008-02-14

=cut
