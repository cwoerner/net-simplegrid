use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.


# NOTE: this is not compatible with Darwin
# TODO: use nicl utils to create the group
# TODO: use nicl utils to create the user

WriteMakefile(
    NAME              => 'Net::SimpleGrid',
    VERSION_FROM      => 'lib/Net/SimpleGrid.pm',
    PREREQ_PM         => {
	Getopt::Long => "",
	File::Spec => "",
	URI => "",
	Socket => "",
	IPC::SysV => "",
	IO::Handle => "",
	POSIX => "",
	Sys::Hostname => "",

	Text::CSV_XS => "",
	HTTP::Request => "",
	LWP::UserAgent => "",
	HTML::Parser => "",

	DBI => "",
	DBD::mysql => "",

	Mail::RFC822::Address => "",
	Net::DNS => "",
	Net::SMTP => "",
    },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Net/SimpleGrid.pm', # retrieve abstract from module
       AUTHOR         => 'Charles Woerner <charleswoerner@gmail.com>') : ()),
    INSTALLSCRIPT => "/opt/simple-grid/bin/",
    INSTALLSITELIB => "/opt/simple-grid/perl/sitelib",
    EXE_FILES => ["bin/master.pl", "bin/slave.pl", "bin/run-slave.sh", "bin/run-master.sh", "bin/node-manager.pl", "bin/config.sh"],
);

package MY;
sub MY::install {
    my $make = shift->SUPER::install(@_);

    $make .= <<'EOMAKE';

OPTDIR=/opt/
INSTDIR=${OPTDIR}simple-grid
BINDIR=${INSTDIR}/bin
CONFDIR=${INSTDIR}/conf
PERLDIR=${INSTDIR}/perl
SITELIBDIR=${PERLDIR}/sitelib
CONF_OWNER=ecgrid
CONF_GROUP=ecgrid
CONF_MODE=644

groups ::
	if [ -z `cat /etc/group | awk -F: '{print $$1}' | grep $(CONF_GROUP)` ]; then \
		groupadd $(CONF_GROUP); \
	fi;

users :: groups
	if [ -z `cat /etc/passwd | awk -F: '{print $$1}' | grep $(CONF_OWNER)` ]; then \
		adduser -d /home/$(CONF_OWNER) -g $(CONF_GROUP) -s /bin/bash $(CONF_OWNER); \
	fi;

dirs :: users
	install -d -g root -m 755 -o root ${OPTDIR};
	install -d -g root -m 775 -o root $(INSTDIR);
	install -d -g root -m 775 -o root $(BINDIR);
	install -d -g $(CONF_GROUP) -m 775 -o $(CONF_OWNER) $(CONF);
	install -d -g root -m 775 -o root $(PERLDIR);
	install -d -g root -m 775 -o root $(SITELIBDIR);
	if [ ! -L $(INSTDIR)/lib ]; then ln -s $(SITELIBDIR) $(INSTDIR)/lib; fi;

install :: dirs
	cd conf; \
	for f in `find . | grep -v '.cvs' | grep -v '^$$' | grep -v '.svn'`; do\
		install -g $(CONF_GROUP) -m $(CONF_MODE) -o $(CONF_OWNER) $$f $(CONFDIR)/$$f; \
	done;

	install -g $(CONF_GROUP) -m $(CONF_MODE) -o $(CONF_OWNER) README $(INSTDIR)/README;

serverconf ::
	@while [ -z "$$REPLY" ]; do \
		read -p "server fqdn on which the mysql server is running: "; \
		if [ -z "$$REPLY" ]; then echo "missing domain name!"; fi; \
	done

EOMAKE
    ;

    return $make;
}

1;
