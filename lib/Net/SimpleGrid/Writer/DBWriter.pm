package Net::SimpleGrid::Writer::DBWriter;

use strict;
use warnings;
use DBI;

use base 'Net::SimpleGrid::Writer';

sub new { 
    my ($class, %opts) = @_;
    $class = ref($class) || $class;

    my $self = $class->SUPER::new(%opts);
    bless $self, $class;

    return $self;
}

# dbh doesn't let you reuse a database connection in a fork()'d child
sub clone { 
    return $_[0]->new(dsn => $_[0]->dsn, username => $_[0]->username, password => $_[0]->password);
}

sub dsn { @_ > 1 && ($_[0]->{dsn} = $_[1]); $_[0]->{dsn}; }
sub username { @_ > 1 && ($_[0]->{username} = $_[1]); $_[0]->{username}; }
sub password { @_ > 1 && ($_[0]->{password} = $_[1]); $_[0]->{password}; }

sub sql {
    my ($self, $s) = @_;
    
    if ($s) { 
	$self->{sql} = $s;
    }

    return $self->{sql};
}


sub dbh { 
    my ($self) = shift;

    if (@_) { 
	$self->{dbh} = shift;
    } else { 

	if (!$self->{dbh}) { 
	    
	    my ($err);
	    
	    for (my $i = 0; $i < 5 && !$self->{dbh}; $i++) { 
		undef $err;
		if (!($self->{dbh} = DBI->connect($self->dsn, $self->username, $self->password)) ) {
		    $err = $DBI::errstr;
		    warn "child [$$] db connection " . $self->username . "\@" . $self->dsn . ", sleeping before trying again: $err\n";
		    sleep(2);
		}
	    }
	    
	    if (!$self->{dbh}) { 
		die "child [$$] failed to connect to db: $err\n";
	    }
	}
    }

    return $self->{dbh};
}

sub sth {
    my $self = shift;
    
    if (!$self->{sth}) { 
	my $sql = $self->sql || die "must set sql before calling sth\n";
	my ($dbh, $have_active_dbh);
	for (my $i = 0; $i < 5 && !$have_active_dbh; $i++) { 
	    $dbh = $self->dbh;
	    if (!($dbh && $dbh->{Active})) { 
		warn "dbh is not active, disconnecting and reconnecting\n";
		eval { $dbh->disconnect; $self->dbh(undef); }
	    } else {
		$have_active_dbh = 1;
	    }
	}

	if (!($dbh && $dbh->{Active})) { 
	    die "failed to get active database handle";
	}

	eval { 
	    $self->{sth} = $dbh->prepare($sql)
		|| die "failed to prepare statement: " . $self->dbh->errstr; 
	};
	if ($@) { 
	    eval { $self->{dbh}->disconnect; }
	}
    }

    return $self->{sth};
}

sub write {
    # duns, url, company_description
    my ($self, $args) = @_;

    my $sth = $self->sth || die "failed to get statement handle\n";
    $sth->execute(@$args) || die "failed to execute: " . $self->sth->errstr . "\n";
    $sth->finish;
    return 1;
}

sub harvest {
    ; # noop - get them yourself!
}

sub DESTROY { if (defined $_[0]) { $_[0]->dbh->disconnect; } }

1;
