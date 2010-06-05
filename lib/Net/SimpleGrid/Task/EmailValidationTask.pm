package Net::SimpleGrid::Task::EmailValidationTask;


=head1 NAME

Net::SimpleGrid::Task::EmailValidationTask - task to test the validity of email addresses

=head1 SYNOPSIS

 my $task = Net::SimpleGrid::Task::EmailValidationTask->new(dsn => 'dbi:mysql:...', username => 'xxx', password => 'xxx');
 $task->handle([$address]);

=head1 DESCRIPTION

This task attempts to validate email addresses using three criteria:

=over 4

=item 1

Is the email address in compliance with RFC 822?

=item 2

Does the email address domain correspond to a valid MX record in DNS?

=item 3

Does the user exist at that domain?

=back

=head1 INPUT

Data should be pre-sorted on email domain before running this task!  This is especially important in case you want to use the dlimit task arg.  See the section on L<TASK ARGS>.  The input stream should be simply email addresses.

=head1 DATABASE

This task expects to be configured with a dsn(), username(), and password().  It expects the dsn() to point to a database
which contains a table called "email_validation" in the following form:

    mysql> describe email_validation
    +-------------+-------------+------+-----+---------+-------+
    | Field       | Type        | Null | Key | Default | Extra |
    +-------------+-------------+------+-----+---------+-------+
    | address     | varchar(100)| YES  |     | NULL    |       |
    | score       | int         | NO   |     | NULL    |       |
    | message     | varchar(50) | YES  |     | NULL    |       |
    +-------------+-------------+------+-----+---------+-------+

=head1 SCORING

The "email_validation"."score" column represents a value that reflects the validity of the address.  It is computed according
to the following algorithm:

 = 0 unless the domain has an MX record
 + 2 if the address is in compliance with RFC 822
 + 4 if the user is validated to exist at that domain
 - 1 if the user is validated not to exist at that domain
 + 0 if the mailserver is up but we were unable to perform validation against the user for some reason

So a fully validated email address will have score 6, whereas an address corresponding to a domain that has no MX record will be 0.  If the address is valid AND the domain has an MX record but we were unable to determine whether the user exists at the domain the score will be 2.  If the address is valid RFC 822 format AND the domain has an MX record but the mailserver said that no account exists for that name then the score will be odd (ie. $score & 1).

=head1 TASK ARGS

Any name=value pairs assigned to the slave.pl command line switch called --task_arg will be passed to the task and the corresponding named property will be set accordingly.  EmailValidationTask supports the following "task args":

=over

=item 

username - the db username, passed to the DBWriter

=item

password - the db password, passed to the DBWriter

=item

dsn - the db connection string, passed to the DBWriter

=item

dlimit - the maximum number of attempts (per domain) to try to initiate smtp conversations with an smtp server at a particular domain.  This applies per-slave node only.

=item

smtpehlo - the mail domain to use in the smtp EHLO/HELO command when identifying ourselves.  Defaults to "localhost".

=item

smtpfrom - the email address from which we are reporting that the smtp conversation is originating from.  Defaults to $USER @ smtpehlo().

=back

=head1 AUTHOR

Charles Woerner E<lt>charleswoerner@gmail.comE<gt>, 2008-02-20

=cut

use strict;
use warnings;

use Net::DNS;
use Net::SMTP;
use Mail::RFC822::Address qw/valid/;
use Net::SimpleGrid::Writer::DBWriter;

use base 'Net::SimpleGrid::Task';

use constant DLIMIT_NONE => -1;

sub new { 
    my ($class, %opts) = @_;
    $class = ref($class) || $class;

    my $self = $class->SUPER::new(%opts);
    bless $self, $class;

    if (!($self->dsn && $self->username && $self->password)) { 
	die "missing dsn, username or password in EmailValidationTask constructor!";
    }

    $self->writer(Net::SimpleGrid::Writer::DBWriter->new);
    $self->writer->dsn($self->dsn);
    $self->writer->username($self->username);
    $self->writer->password($self->password);
    $self->writer->sql("insert into email_validation (address, score, message) values (?, ?, ?)");

    return $self;
}

sub prepare {
    my ($self) = @_;

    my $dbh = $self->writer->dbh;

    $dbh->do("describe email_validation") || 
	$dbh->do("create table email_validation (address varchar(100), score int, message varchar(100) )") ||
	die "failed to create email_validation table: " . $dbh->errstr;
}

sub smtpfrom { 
    my ($self, $addr) = @_;

    if (defined $addr) { 
	$self->{smtpfrom} = $addr;
    }

    return $self->{smtpfrom} || (sprintf("%s@%s", $ENV{USER}, $self->smtpehlo));
}

sub smtpehlo { 
    my ($self, $dom) = @_;

    if (defined $dom) { 
	$self->{domain} = $dom;
    }

    return $self->{domain} || "localhost";
}

sub dlimit {
    my ($self, $limit) = @_;

    if (defined $limit) { 
	sprintf("%d", $limit) eq $limit or die "invalid dlimit '$limit'";
	$self->{per_domain_limit} = $limit;
    }

    return defined($self->{per_domain_limit}) ? $self->{per_domain_limit} : DLIMIT_NONE;
}

sub dsn { @_ > 1 && ($_[0]->{dsn} = $_[1]); $_[0]->{dsn}; }
sub username { @_ > 1 && ($_[0]->{username} = $_[1]); $_[0]->{username}; }
sub password { @_ > 1 && ($_[0]->{password} = $_[1]); $_[0]->{password}; }

sub getDomainForAddress {
    my ($self, $addr) = @_;
    $addr =~ /.*?\@\s*([a-zA-Z0-9_\-\.]+)/;
    return $1;
}

{
    my $resolver = Net::DNS::Resolver->new;
    sub getMXRecords {
	my ($self, $domain) = @_;
	my @mx  = sort { $a->preference <=> $b->preference } mx($resolver, $domain);
	warn("Can't find MX records for $domain: ", $resolver->errorstring, "\n") unless @mx;
	return @mx;
    }
};


sub smtpConn { 
    my ($self, $mx) = @_;

    if (!$self->{smtp_conn}) { 
	$self->{smtp_conn} = Net::SMTP->new($mx->exchange, Hello => $self->smtpehlo);
    }

    return $self->{smtp_conn};
}

sub testSMTPConversation {
    my ($self, $rec) = @_;
    
    my $is_valid = 0;

  PREFS:
    foreach my $mx (@{$rec->{mx}}) { 
	my $smtp;
	eval { 
	    $smtp = $self->smtpConn($mx);	    
	    $is_valid = $smtp->mail($self->smtpfrom) && $smtp->recipient($rec->{address});
	};
	if ($@) { 
	    warn "failed to contact mail exchanger '" . $mx->exchange . "' preference " . $mx->preference . ": $@\n";
	}

	if (!$is_valid) { 
	    $rec->{message} = $smtp->message if $smtp;
	}

	eval { $smtp->reset; };

	last PREFS if $is_valid;
    }

    return $is_valid;
}

sub doTask {
    my ($self, $fields) = @_;

    #print STDERR "worker [$$] doing task '@$fields'\n";

    my $addr = $fields->[0];
    my $domain;
    if (!($domain = $self->getDomainForAddress($addr)) ) { 
	warn "failed to determine domain for address '$addr'";
	return;
    }

    my $rec = {
	address => $addr,
	score => 0,
	domain => $domain,
	mx => undef,
	message => undef,
    };

    if ($self->count && $self->getData(0)->{domain} ne $domain) { 
	$self->flush();
    } 

    my @mx;
    if (!Mail::RFC822::Address::valid($rec->{address})) { 
	$rec->{score} = 0;
    } elsif ($self->count == 0) {
	$rec->{mx} = [$self->getMXRecords($rec->{domain})];
	$rec->{score} += (scalar(@{$rec->{mx}}) ? 2 : 0);
    } else {
	$rec->{mx} = $self->getData(0)->{mx};
	$rec->{score} += ($self->getData(0)->{score} & 2);
    }

    if (($rec->{score} & 2) && (($self->dlimit == DLIMIT_NONE) || ($self->count < $self->dlimit))) { 
	$rec->{score} += ($self->testSMTPConversation($rec) * 4);
    }

    $self->addData($rec);
    
    return 1;
}

sub flush {
    my ($self) = @_;

    if (my $cnt = $self->count) { 
	my $data;
	for (0 .. ($self->count - 1)) {
	    $data = $self->getData($_);
	    $self->writer->write([$data->{address}, $data->{score}, $data->{message}]);
	}
	
	if ($self->{smtp_conn}) { 
	    eval { 
		$self->{smtp_conn}->quit;
		$self->{smtp_conn} = undef;
	    };
	}
    }

    $self->clearData();
}

sub reset {}

sub onComplete {
    $_[0]->flush;
}

1;
