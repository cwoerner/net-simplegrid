# This Makefile is for the Net::SimpleGrid extension to perl.
#
# It was generated automatically by MakeMaker version
# 6.48 (Revision: 64800) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#       ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker ARGV: ()
#
#   MakeMaker Parameters:

#     ABSTRACT_FROM => q[lib/Net/SimpleGrid.pm]
#     AUTHOR => q[Charles Woerner <charleswoerner@gmail.com>]
#     EXE_FILES => [q[bin/master.pl], q[bin/slave.pl], q[bin/run-slave.sh], q[bin/run-master.sh], q[bin/node-manager.pl], q[bin/config.sh]]
#     INSTALLSCRIPT => q[/opt/simple-grid/bin/]
#     INSTALLSITELIB => q[/opt/simple-grid/perl/sitelib]
#     NAME => q[Net::SimpleGrid]
#     PREREQ_PM => { IO::Handle=>q[], File::Spec=>q[], Mail::RFC822::Address=>q[], POSIX=>q[], Text::CSV_XS=>q[], Socket=>q[], DBI=>q[], Getopt::Long=>q[], URI=>q[], Net::SMTP=>q[], LWP::UserAgent=>q[], Net::DNS=>q[], IPC::SysV=>q[], HTML::Parser=>q[], DBD::mysql=>q[], HTTP::Request=>q[], Sys::Hostname=>q[] }
#     VERSION_FROM => q[lib/Net/SimpleGrid.pm]

# --- MakeMaker post_initialize section:


# --- MakeMaker const_config section:

# These definitions are from config.sh (via /opt/local/lib/perl5/5.8.9/darwin-2level/Config.pm).
# They may have been overridden via Makefile.PL or on the command line.
AR = ar
CC = /usr/bin/gcc-4.2
CCCDLFLAGS =  
CCDLFLAGS =  
DLEXT = bundle
DLSRC = dl_dlopen.xs
EXE_EXT = 
FULL_AR = /usr/bin/ar
LD = env MACOSX_DEPLOYMENT_TARGET=10.3 /usr/bin/gcc-4.2
LDDLFLAGS = -L/opt/local/lib -arch x86_64 -bundle -undefined dynamic_lookup -L/usr/local/lib
LDFLAGS = -L/opt/local/lib -arch x86_64 -L/usr/local/lib
LIBC = /usr/lib/libc.dylib
LIB_EXT = .a
OBJ_EXT = .o
OSNAME = darwin
OSVERS = 10.3.1
RANLIB = ranlib
SITELIBEXP = /opt/local/lib/perl5/site_perl/5.8.9
SITEARCHEXP = /opt/local/lib/perl5/site_perl/5.8.9/darwin-2level
SO = dylib
VENDORARCHEXP = /opt/local/lib/perl5/vendor_perl/5.8.9/darwin-2level
VENDORLIBEXP = /opt/local/lib/perl5/vendor_perl/5.8.9


# --- MakeMaker constants section:
AR_STATIC_ARGS = cr
DIRFILESEP = /
DFSEP = $(DIRFILESEP)
NAME = Net::SimpleGrid
NAME_SYM = Net_SimpleGrid
VERSION = 0.09
VERSION_MACRO = VERSION
VERSION_SYM = 0_09
DEFINE_VERSION = -D$(VERSION_MACRO)=\"$(VERSION)\"
XS_VERSION = 0.09
XS_VERSION_MACRO = XS_VERSION
XS_DEFINE_VERSION = -D$(XS_VERSION_MACRO)=\"$(XS_VERSION)\"
INST_ARCHLIB = blib/arch
INST_SCRIPT = blib/script
INST_BIN = blib/bin
INST_LIB = blib/lib
INST_MAN1DIR = blib/man1
INST_MAN3DIR = blib/man3
MAN1EXT = 1pm
MAN3EXT = 3pm
INSTALLDIRS = site
DESTDIR = 
PREFIX = $(SITEPREFIX)
PERLPREFIX = /opt/local
SITEPREFIX = /opt/local
VENDORPREFIX = /opt/local
INSTALLPRIVLIB = /opt/local/lib/perl5/5.8.9
DESTINSTALLPRIVLIB = $(DESTDIR)$(INSTALLPRIVLIB)
INSTALLSITELIB = /opt/simple-grid/perl/sitelib
DESTINSTALLSITELIB = $(DESTDIR)$(INSTALLSITELIB)
INSTALLVENDORLIB = /opt/local/lib/perl5/vendor_perl/5.8.9
DESTINSTALLVENDORLIB = $(DESTDIR)$(INSTALLVENDORLIB)
INSTALLARCHLIB = /opt/local/lib/perl5/5.8.9/darwin-2level
DESTINSTALLARCHLIB = $(DESTDIR)$(INSTALLARCHLIB)
INSTALLSITEARCH = /opt/local/lib/perl5/site_perl/5.8.9/darwin-2level
DESTINSTALLSITEARCH = $(DESTDIR)$(INSTALLSITEARCH)
INSTALLVENDORARCH = /opt/local/lib/perl5/vendor_perl/5.8.9/darwin-2level
DESTINSTALLVENDORARCH = $(DESTDIR)$(INSTALLVENDORARCH)
INSTALLBIN = /opt/local/bin
DESTINSTALLBIN = $(DESTDIR)$(INSTALLBIN)
INSTALLSITEBIN = /opt/local/bin
DESTINSTALLSITEBIN = $(DESTDIR)$(INSTALLSITEBIN)
INSTALLVENDORBIN = /opt/local/bin
DESTINSTALLVENDORBIN = $(DESTDIR)$(INSTALLVENDORBIN)
INSTALLSCRIPT = /opt/simple-grid/bin/
DESTINSTALLSCRIPT = $(DESTDIR)$(INSTALLSCRIPT)
INSTALLSITESCRIPT = /opt/local/bin
DESTINSTALLSITESCRIPT = $(DESTDIR)$(INSTALLSITESCRIPT)
INSTALLVENDORSCRIPT = /opt/local/bin
DESTINSTALLVENDORSCRIPT = $(DESTDIR)$(INSTALLVENDORSCRIPT)
INSTALLMAN1DIR = /opt/local/share/man/man1p
DESTINSTALLMAN1DIR = $(DESTDIR)$(INSTALLMAN1DIR)
INSTALLSITEMAN1DIR = /opt/local/share/man/man1
DESTINSTALLSITEMAN1DIR = $(DESTDIR)$(INSTALLSITEMAN1DIR)
INSTALLVENDORMAN1DIR = /opt/local/share/man/man1
DESTINSTALLVENDORMAN1DIR = $(DESTDIR)$(INSTALLVENDORMAN1DIR)
INSTALLMAN3DIR = /opt/local/share/man/man3p
DESTINSTALLMAN3DIR = $(DESTDIR)$(INSTALLMAN3DIR)
INSTALLSITEMAN3DIR = /opt/local/share/man/man3
DESTINSTALLSITEMAN3DIR = $(DESTDIR)$(INSTALLSITEMAN3DIR)
INSTALLVENDORMAN3DIR = /opt/local/share/man/man3
DESTINSTALLVENDORMAN3DIR = $(DESTDIR)$(INSTALLVENDORMAN3DIR)
PERL_LIB = /opt/local/lib/perl5/5.8.9
PERL_ARCHLIB = /opt/local/lib/perl5/5.8.9/darwin-2level
LIBPERL_A = libperl.a
FIRST_MAKEFILE = Makefile
MAKEFILE_OLD = Makefile.old
MAKE_APERL_FILE = Makefile.aperl
PERLMAINCC = $(CC)
PERL_INC = /opt/local/lib/perl5/5.8.9/darwin-2level/CORE
PERL = /opt/local/bin/perl
FULLPERL = /opt/local/bin/perl
ABSPERL = $(PERL)
PERLRUN = $(PERL)
FULLPERLRUN = $(FULLPERL)
ABSPERLRUN = $(ABSPERL)
PERLRUNINST = $(PERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
FULLPERLRUNINST = $(FULLPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
ABSPERLRUNINST = $(ABSPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
PERL_CORE = 0
PERM_RW = 644
PERM_RWX = 755

MAKEMAKER   = /opt/local/lib/perl5/5.8.9/ExtUtils/MakeMaker.pm
MM_VERSION  = 6.48
MM_REVISION = 64800

# FULLEXT = Pathname for extension directory (eg Foo/Bar/Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT. (eg Oracle)
# PARENT_NAME = NAME without BASEEXT and no trailing :: (eg Foo::Bar)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
MAKE = make
FULLEXT = Net/SimpleGrid
BASEEXT = SimpleGrid
PARENT_NAME = Net
DLBASE = $(BASEEXT)
VERSION_FROM = lib/Net/SimpleGrid.pm
OBJECT = 
LDFROM = $(OBJECT)
LINKTYPE = dynamic
BOOTDEP = 

# Handy lists of source code files:
XS_FILES = 
C_FILES  = 
O_FILES  = 
H_FILES  = 
MAN1PODS = bin/master.pl \
	bin/node-manager.pl \
	bin/slave.pl
MAN3PODS = lib/Net/SimpleGrid.pm \
	lib/Net/SimpleGrid/Manager.pm \
	lib/Net/SimpleGrid/Node.pm \
	lib/Net/SimpleGrid/States.pm \
	lib/Net/SimpleGrid/Task/CompanyDescriptionTask.pm \
	lib/Net/SimpleGrid/Task/EmailValidationTask.pm

# Where is the Config information that we are using/depend on
CONFIGDEP = $(PERL_ARCHLIB)$(DFSEP)Config.pm $(PERL_INC)$(DFSEP)config.h

# Where to build things
INST_LIBDIR      = $(INST_LIB)/Net
INST_ARCHLIBDIR  = $(INST_ARCHLIB)/Net

INST_AUTODIR     = $(INST_LIB)/auto/$(FULLEXT)
INST_ARCHAUTODIR = $(INST_ARCHLIB)/auto/$(FULLEXT)

INST_STATIC      = 
INST_DYNAMIC     = 
INST_BOOT        = 

# Extra linker info
EXPORT_LIST        = 
PERL_ARCHIVE       = 
PERL_ARCHIVE_AFTER = 


TO_INST_PM = lib/Net/SimpleGrid.pm \
	lib/Net/SimpleGrid/Manager.pm \
	lib/Net/SimpleGrid/Node.pm \
	lib/Net/SimpleGrid/ProcessScheduler.pm \
	lib/Net/SimpleGrid/ProcessScheduler/PartitionedStrategy.pm \
	lib/Net/SimpleGrid/ProcessScheduler/RoundRobinStrategy.pm \
	lib/Net/SimpleGrid/Scheduler.pm \
	lib/Net/SimpleGrid/Scheduler/PartitionedStrategy.pm \
	lib/Net/SimpleGrid/Scheduler/PartitionedStrategy/ByEmailDomain.pm \
	lib/Net/SimpleGrid/Scheduler/RoundRobinStrategy.pm \
	lib/Net/SimpleGrid/Slave.pm \
	lib/Net/SimpleGrid/States.pm \
	lib/Net/SimpleGrid/Task.pm \
	lib/Net/SimpleGrid/Task/CompanyDescriptionTask.pm \
	lib/Net/SimpleGrid/Task/EmailValidationTask.pm \
	lib/Net/SimpleGrid/Writer.pm \
	lib/Net/SimpleGrid/Writer/CSVWriter.pm \
	lib/Net/SimpleGrid/Writer/DBWriter.pm

PM_TO_BLIB = lib/Net/SimpleGrid/Scheduler/PartitionedStrategy.pm \
	blib/lib/Net/SimpleGrid/Scheduler/PartitionedStrategy.pm \
	lib/Net/SimpleGrid/Writer/DBWriter.pm \
	blib/lib/Net/SimpleGrid/Writer/DBWriter.pm \
	lib/Net/SimpleGrid/Manager.pm \
	blib/lib/Net/SimpleGrid/Manager.pm \
	lib/Net/SimpleGrid/Scheduler/RoundRobinStrategy.pm \
	blib/lib/Net/SimpleGrid/Scheduler/RoundRobinStrategy.pm \
	lib/Net/SimpleGrid/Task.pm \
	blib/lib/Net/SimpleGrid/Task.pm \
	lib/Net/SimpleGrid/Writer.pm \
	blib/lib/Net/SimpleGrid/Writer.pm \
	lib/Net/SimpleGrid/States.pm \
	blib/lib/Net/SimpleGrid/States.pm \
	lib/Net/SimpleGrid/Slave.pm \
	blib/lib/Net/SimpleGrid/Slave.pm \
	lib/Net/SimpleGrid/Writer/CSVWriter.pm \
	blib/lib/Net/SimpleGrid/Writer/CSVWriter.pm \
	lib/Net/SimpleGrid/ProcessScheduler/PartitionedStrategy.pm \
	blib/lib/Net/SimpleGrid/ProcessScheduler/PartitionedStrategy.pm \
	lib/Net/SimpleGrid/Task/CompanyDescriptionTask.pm \
	blib/lib/Net/SimpleGrid/Task/CompanyDescriptionTask.pm \
	lib/Net/SimpleGrid/ProcessScheduler/RoundRobinStrategy.pm \
	blib/lib/Net/SimpleGrid/ProcessScheduler/RoundRobinStrategy.pm \
	lib/Net/SimpleGrid/Scheduler.pm \
	blib/lib/Net/SimpleGrid/Scheduler.pm \
	lib/Net/SimpleGrid/Scheduler/PartitionedStrategy/ByEmailDomain.pm \
	blib/lib/Net/SimpleGrid/Scheduler/PartitionedStrategy/ByEmailDomain.pm \
	lib/Net/SimpleGrid.pm \
	blib/lib/Net/SimpleGrid.pm \
	lib/Net/SimpleGrid/ProcessScheduler.pm \
	blib/lib/Net/SimpleGrid/ProcessScheduler.pm \
	lib/Net/SimpleGrid/Task/EmailValidationTask.pm \
	blib/lib/Net/SimpleGrid/Task/EmailValidationTask.pm \
	lib/Net/SimpleGrid/Node.pm \
	blib/lib/Net/SimpleGrid/Node.pm


# --- MakeMaker platform_constants section:
MM_Unix_VERSION = 6.48
PERL_MALLOC_DEF = -DPERL_EXTMALLOC_DEF -Dmalloc=Perl_malloc -Dfree=Perl_mfree -Drealloc=Perl_realloc -Dcalloc=Perl_calloc


# --- MakeMaker tool_autosplit section:
# Usage: $(AUTOSPLITFILE) FileToSplit AutoDirToSplitInto
AUTOSPLITFILE = $(ABSPERLRUN)  -e 'use AutoSplit;  autosplit($$ARGV[0], $$ARGV[1], 0, 1, 1)' --



# --- MakeMaker tool_xsubpp section:


# --- MakeMaker tools_other section:
SHELL = /bin/sh
CHMOD = chmod
CP = cp
MV = mv
NOOP = $(SHELL) -c true
NOECHO = @
RM_F = rm -f
RM_RF = rm -rf
TEST_F = test -f
TOUCH = touch
UMASK_NULL = umask 0
DEV_NULL = > /dev/null 2>&1
MKPATH = $(ABSPERLRUN) "-MExtUtils::Command" -e mkpath
EQUALIZE_TIMESTAMP = $(ABSPERLRUN) "-MExtUtils::Command" -e eqtime
ECHO = echo
ECHO_N = echo -n
UNINST = 0
VERBINST = 0
MOD_INSTALL = $(ABSPERLRUN) -MExtUtils::Install -e 'install({@ARGV}, '\''$(VERBINST)'\'', 0, '\''$(UNINST)'\'');' --
DOC_INSTALL = $(ABSPERLRUN) "-MExtUtils::Command::MM" -e perllocal_install
UNINSTALL = $(ABSPERLRUN) "-MExtUtils::Command::MM" -e uninstall
WARN_IF_OLD_PACKLIST = $(ABSPERLRUN) "-MExtUtils::Command::MM" -e warn_if_old_packlist
MACROSTART = 
MACROEND = 
USEMAKEFILE = -f
FIXIN = $(PERLRUN) "-MExtUtils::MY" -e "MY->fixin(shift)"


# --- MakeMaker makemakerdflt section:
makemakerdflt : all
	$(NOECHO) $(NOOP)


# --- MakeMaker dist section:
TAR = COPY_EXTENDED_ATTRIBUTES_DISABLE=1 COPYFILE_DISABLE=1 tar
TARFLAGS = cvf
ZIP = zip
ZIPFLAGS = -r
COMPRESS = gzip --best
SUFFIX = .gz
SHAR = shar
PREOP = $(NOECHO) $(NOOP)
POSTOP = $(NOECHO) $(NOOP)
TO_UNIX = $(NOECHO) $(NOOP)
CI = ci -u
RCS_LABEL = rcs -Nv$(VERSION_SYM): -q
DIST_CP = best
DIST_DEFAULT = tardist
DISTNAME = Net-SimpleGrid
DISTVNAME = Net-SimpleGrid-0.09


# --- MakeMaker macro section:


# --- MakeMaker depend section:


# --- MakeMaker cflags section:


# --- MakeMaker const_loadlibs section:


# --- MakeMaker const_cccmd section:


# --- MakeMaker post_constants section:


# --- MakeMaker pasthru section:

PASTHRU = LIBPERL_A="$(LIBPERL_A)"\
	LINKTYPE="$(LINKTYPE)"\
	PREFIX="$(PREFIX)"


# --- MakeMaker special_targets section:
.SUFFIXES : .xs .c .C .cpp .i .s .cxx .cc $(OBJ_EXT)

.PHONY: all config static dynamic test linkext manifest blibdirs clean realclean disttest distdir



# --- MakeMaker c_o section:


# --- MakeMaker xs_c section:


# --- MakeMaker xs_o section:


# --- MakeMaker top_targets section:
all :: pure_all manifypods
	$(NOECHO) $(NOOP)


pure_all :: config pm_to_blib subdirs linkext
	$(NOECHO) $(NOOP)

subdirs :: $(MYEXTLIB)
	$(NOECHO) $(NOOP)

config :: $(FIRST_MAKEFILE) blibdirs
	$(NOECHO) $(NOOP)

help :
	perldoc ExtUtils::MakeMaker


# --- MakeMaker blibdirs section:
blibdirs : $(INST_LIBDIR)$(DFSEP).exists $(INST_ARCHLIB)$(DFSEP).exists $(INST_AUTODIR)$(DFSEP).exists $(INST_ARCHAUTODIR)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists $(INST_SCRIPT)$(DFSEP).exists $(INST_MAN1DIR)$(DFSEP).exists $(INST_MAN3DIR)$(DFSEP).exists
	$(NOECHO) $(NOOP)

# Backwards compat with 6.18 through 6.25
blibdirs.ts : blibdirs
	$(NOECHO) $(NOOP)

$(INST_LIBDIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_LIBDIR)
	$(NOECHO) $(CHMOD) 755 $(INST_LIBDIR)
	$(NOECHO) $(TOUCH) $(INST_LIBDIR)$(DFSEP).exists

$(INST_ARCHLIB)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHLIB)
	$(NOECHO) $(CHMOD) 755 $(INST_ARCHLIB)
	$(NOECHO) $(TOUCH) $(INST_ARCHLIB)$(DFSEP).exists

$(INST_AUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_AUTODIR)
	$(NOECHO) $(CHMOD) 755 $(INST_AUTODIR)
	$(NOECHO) $(TOUCH) $(INST_AUTODIR)$(DFSEP).exists

$(INST_ARCHAUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHAUTODIR)
	$(NOECHO) $(CHMOD) 755 $(INST_ARCHAUTODIR)
	$(NOECHO) $(TOUCH) $(INST_ARCHAUTODIR)$(DFSEP).exists

$(INST_BIN)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_BIN)
	$(NOECHO) $(CHMOD) 755 $(INST_BIN)
	$(NOECHO) $(TOUCH) $(INST_BIN)$(DFSEP).exists

$(INST_SCRIPT)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_SCRIPT)
	$(NOECHO) $(CHMOD) 755 $(INST_SCRIPT)
	$(NOECHO) $(TOUCH) $(INST_SCRIPT)$(DFSEP).exists

$(INST_MAN1DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN1DIR)
	$(NOECHO) $(CHMOD) 755 $(INST_MAN1DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN1DIR)$(DFSEP).exists

$(INST_MAN3DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN3DIR)
	$(NOECHO) $(CHMOD) 755 $(INST_MAN3DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN3DIR)$(DFSEP).exists



# --- MakeMaker linkext section:

linkext :: $(LINKTYPE)
	$(NOECHO) $(NOOP)


# --- MakeMaker dlsyms section:


# --- MakeMaker dynamic section:

dynamic :: $(FIRST_MAKEFILE) $(INST_DYNAMIC) $(INST_BOOT)
	$(NOECHO) $(NOOP)


# --- MakeMaker dynamic_bs section:

BOOTSTRAP =


# --- MakeMaker dynamic_lib section:


# --- MakeMaker static section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make static"
static :: $(FIRST_MAKEFILE) $(INST_STATIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker static_lib section:


# --- MakeMaker manifypods section:

POD2MAN_EXE = $(PERLRUN) "-MExtUtils::Command::MM" -e pod2man "--"
POD2MAN = $(POD2MAN_EXE)


manifypods : pure_all  \
	bin/node-manager.pl \
	bin/slave.pl \
	bin/master.pl \
	lib/Net/SimpleGrid/States.pm \
	lib/Net/SimpleGrid.pm \
	lib/Net/SimpleGrid/Manager.pm \
	lib/Net/SimpleGrid/Task/EmailValidationTask.pm \
	lib/Net/SimpleGrid/Node.pm \
	lib/Net/SimpleGrid/Task/CompanyDescriptionTask.pm
	$(NOECHO) $(POD2MAN) --section=1 --perm_rw=$(PERM_RW) \
	  bin/node-manager.pl $(INST_MAN1DIR)/node-manager.pl.$(MAN1EXT) \
	  bin/slave.pl $(INST_MAN1DIR)/slave.pl.$(MAN1EXT) \
	  bin/master.pl $(INST_MAN1DIR)/master.pl.$(MAN1EXT) 
	$(NOECHO) $(POD2MAN) --section=3 --perm_rw=$(PERM_RW) \
	  lib/Net/SimpleGrid/States.pm $(INST_MAN3DIR)/Net::SimpleGrid::States.$(MAN3EXT) \
	  lib/Net/SimpleGrid.pm $(INST_MAN3DIR)/Net::SimpleGrid.$(MAN3EXT) \
	  lib/Net/SimpleGrid/Manager.pm $(INST_MAN3DIR)/Net::SimpleGrid::Manager.$(MAN3EXT) \
	  lib/Net/SimpleGrid/Task/EmailValidationTask.pm $(INST_MAN3DIR)/Net::SimpleGrid::Task::EmailValidationTask.$(MAN3EXT) \
	  lib/Net/SimpleGrid/Node.pm $(INST_MAN3DIR)/Net::SimpleGrid::Node.$(MAN3EXT) \
	  lib/Net/SimpleGrid/Task/CompanyDescriptionTask.pm $(INST_MAN3DIR)/Net::SimpleGrid::Task::CompanyDescriptionTask.$(MAN3EXT) 




# --- MakeMaker processPL section:


# --- MakeMaker installbin section:

EXE_FILES = bin/master.pl bin/slave.pl bin/run-slave.sh bin/run-master.sh bin/node-manager.pl bin/config.sh

pure_all :: $(INST_SCRIPT)/run-master.sh $(INST_SCRIPT)/run-slave.sh $(INST_SCRIPT)/node-manager.pl $(INST_SCRIPT)/config.sh $(INST_SCRIPT)/slave.pl $(INST_SCRIPT)/master.pl
	$(NOECHO) $(NOOP)

realclean ::
	$(RM_F) \
	  $(INST_SCRIPT)/run-master.sh $(INST_SCRIPT)/run-slave.sh \
	  $(INST_SCRIPT)/node-manager.pl $(INST_SCRIPT)/config.sh \
	  $(INST_SCRIPT)/slave.pl $(INST_SCRIPT)/master.pl 

$(INST_SCRIPT)/run-master.sh : bin/run-master.sh $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/run-master.sh
	$(CP) bin/run-master.sh $(INST_SCRIPT)/run-master.sh
	$(FIXIN) $(INST_SCRIPT)/run-master.sh
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/run-master.sh

$(INST_SCRIPT)/run-slave.sh : bin/run-slave.sh $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/run-slave.sh
	$(CP) bin/run-slave.sh $(INST_SCRIPT)/run-slave.sh
	$(FIXIN) $(INST_SCRIPT)/run-slave.sh
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/run-slave.sh

$(INST_SCRIPT)/node-manager.pl : bin/node-manager.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/node-manager.pl
	$(CP) bin/node-manager.pl $(INST_SCRIPT)/node-manager.pl
	$(FIXIN) $(INST_SCRIPT)/node-manager.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/node-manager.pl

$(INST_SCRIPT)/config.sh : bin/config.sh $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/config.sh
	$(CP) bin/config.sh $(INST_SCRIPT)/config.sh
	$(FIXIN) $(INST_SCRIPT)/config.sh
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/config.sh

$(INST_SCRIPT)/slave.pl : bin/slave.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/slave.pl
	$(CP) bin/slave.pl $(INST_SCRIPT)/slave.pl
	$(FIXIN) $(INST_SCRIPT)/slave.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/slave.pl

$(INST_SCRIPT)/master.pl : bin/master.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/master.pl
	$(CP) bin/master.pl $(INST_SCRIPT)/master.pl
	$(FIXIN) $(INST_SCRIPT)/master.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/master.pl



# --- MakeMaker subdirs section:

# none

# --- MakeMaker clean_subdirs section:
clean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean :: clean_subdirs
	- $(RM_F) \
	  *$(LIB_EXT) core \
	  core.[0-9] $(INST_ARCHAUTODIR)/extralibs.all \
	  core.[0-9][0-9] $(BASEEXT).bso \
	  pm_to_blib.ts core.[0-9][0-9][0-9][0-9] \
	  $(BASEEXT).x $(BOOTSTRAP) \
	  perl$(EXE_EXT) tmon.out \
	  *$(OBJ_EXT) pm_to_blib \
	  $(INST_ARCHAUTODIR)/extralibs.ld blibdirs.ts \
	  core.[0-9][0-9][0-9][0-9][0-9] *perl.core \
	  core.*perl.*.? $(MAKE_APERL_FILE) \
	  perl $(BASEEXT).def \
	  core.[0-9][0-9][0-9] mon.out \
	  lib$(BASEEXT).def perlmain.c \
	  perl.exe so_locations \
	  $(BASEEXT).exp 
	- $(RM_RF) \
	  blib 
	- $(MV) $(FIRST_MAKEFILE) $(MAKEFILE_OLD) $(DEV_NULL)


# --- MakeMaker realclean_subdirs section:
realclean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker realclean section:
# Delete temporary files (via clean) and also delete dist files
realclean purge ::  clean realclean_subdirs
	- $(RM_F) \
	  $(MAKEFILE_OLD) $(FIRST_MAKEFILE) 
	- $(RM_RF) \
	  $(DISTVNAME) 


# --- MakeMaker metafile section:
metafile : create_distdir
	$(NOECHO) $(ECHO) Generating META.yml
	$(NOECHO) $(ECHO) '--- #YAML:1.0' > META_new.yml
	$(NOECHO) $(ECHO) 'name:               Net-SimpleGrid' >> META_new.yml
	$(NOECHO) $(ECHO) 'version:            0.09' >> META_new.yml
	$(NOECHO) $(ECHO) 'abstract:           Perl extension for Net grid system' >> META_new.yml
	$(NOECHO) $(ECHO) 'author:' >> META_new.yml
	$(NOECHO) $(ECHO) '    - Charles Woerner <charleswoerner@gmail.com>' >> META_new.yml
	$(NOECHO) $(ECHO) 'license:            unknown' >> META_new.yml
	$(NOECHO) $(ECHO) 'distribution_type:  module' >> META_new.yml
	$(NOECHO) $(ECHO) 'configure_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '    ExtUtils::MakeMaker:  0' >> META_new.yml
	$(NOECHO) $(ECHO) 'requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '    DBD::mysql:           ' >> META_new.yml
	$(NOECHO) $(ECHO) '    DBI:                  ' >> META_new.yml
	$(NOECHO) $(ECHO) '    File::Spec:           ' >> META_new.yml
	$(NOECHO) $(ECHO) '    Getopt::Long:         ' >> META_new.yml
	$(NOECHO) $(ECHO) '    HTML::Parser:         ' >> META_new.yml
	$(NOECHO) $(ECHO) '    HTTP::Request:        ' >> META_new.yml
	$(NOECHO) $(ECHO) '    IO::Handle:           ' >> META_new.yml
	$(NOECHO) $(ECHO) '    IPC::SysV:            ' >> META_new.yml
	$(NOECHO) $(ECHO) '    LWP::UserAgent:       ' >> META_new.yml
	$(NOECHO) $(ECHO) '    Mail::RFC822::Address:  ' >> META_new.yml
	$(NOECHO) $(ECHO) '    Net::DNS:             ' >> META_new.yml
	$(NOECHO) $(ECHO) '    Net::SMTP:            ' >> META_new.yml
	$(NOECHO) $(ECHO) '    POSIX:                ' >> META_new.yml
	$(NOECHO) $(ECHO) '    Socket:               ' >> META_new.yml
	$(NOECHO) $(ECHO) '    Sys::Hostname:        ' >> META_new.yml
	$(NOECHO) $(ECHO) '    Text::CSV_XS:         ' >> META_new.yml
	$(NOECHO) $(ECHO) '    URI:                  ' >> META_new.yml
	$(NOECHO) $(ECHO) 'no_index:' >> META_new.yml
	$(NOECHO) $(ECHO) '    directory:' >> META_new.yml
	$(NOECHO) $(ECHO) '        - t' >> META_new.yml
	$(NOECHO) $(ECHO) '        - inc' >> META_new.yml
	$(NOECHO) $(ECHO) 'generated_by:       ExtUtils::MakeMaker version 6.48' >> META_new.yml
	$(NOECHO) $(ECHO) 'meta-spec:' >> META_new.yml
	$(NOECHO) $(ECHO) '    url:      http://module-build.sourceforge.net/META-spec-v1.4.html' >> META_new.yml
	$(NOECHO) $(ECHO) '    version:  1.4' >> META_new.yml
	-$(NOECHO) $(MV) META_new.yml $(DISTVNAME)/META.yml


# --- MakeMaker signature section:
signature :
	cpansign -s


# --- MakeMaker dist_basics section:
distclean :: realclean distcheck
	$(NOECHO) $(NOOP)

distcheck :
	$(PERLRUN) "-MExtUtils::Manifest=fullcheck" -e fullcheck

skipcheck :
	$(PERLRUN) "-MExtUtils::Manifest=skipcheck" -e skipcheck

manifest :
	$(PERLRUN) "-MExtUtils::Manifest=mkmanifest" -e mkmanifest

veryclean : realclean
	$(RM_F) *~ */*~ *.orig */*.orig *.bak */*.bak *.old */*.old 



# --- MakeMaker dist_core section:

dist : $(DIST_DEFAULT) $(FIRST_MAKEFILE)
	$(NOECHO) $(ABSPERLRUN) -l -e 'print '\''Warning: Makefile possibly out of date with $(VERSION_FROM)'\''' \
	  -e '    if -e '\''$(VERSION_FROM)'\'' and -M '\''$(VERSION_FROM)'\'' < -M '\''$(FIRST_MAKEFILE)'\'';' --

tardist : $(DISTVNAME).tar$(SUFFIX)
	$(NOECHO) $(NOOP)

uutardist : $(DISTVNAME).tar$(SUFFIX)
	uuencode $(DISTVNAME).tar$(SUFFIX) $(DISTVNAME).tar$(SUFFIX) > $(DISTVNAME).tar$(SUFFIX)_uu

$(DISTVNAME).tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME).tar $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME).tar
	$(POSTOP)

zipdist : $(DISTVNAME).zip
	$(NOECHO) $(NOOP)

$(DISTVNAME).zip : distdir
	$(PREOP)
	$(ZIP) $(ZIPFLAGS) $(DISTVNAME).zip $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(POSTOP)

shdist : distdir
	$(PREOP)
	$(SHAR) $(DISTVNAME) > $(DISTVNAME).shar
	$(RM_RF) $(DISTVNAME)
	$(POSTOP)


# --- MakeMaker distdir section:
create_distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"

distdir : create_distdir distmeta 
	$(NOECHO) $(NOOP)



# --- MakeMaker dist_test section:
disttest : distdir
	cd $(DISTVNAME) && $(ABSPERLRUN) Makefile.PL 
	cd $(DISTVNAME) && $(MAKE) $(PASTHRU)
	cd $(DISTVNAME) && $(MAKE) test $(PASTHRU)



# --- MakeMaker dist_ci section:

ci :
	$(PERLRUN) "-MExtUtils::Manifest=maniread" \
	  -e "@all = keys %{ maniread() };" \
	  -e "print(qq{Executing $(CI) @all\n}); system(qq{$(CI) @all});" \
	  -e "print(qq{Executing $(RCS_LABEL) ...\n}); system(qq{$(RCS_LABEL) @all});"


# --- MakeMaker distmeta section:
distmeta : create_distdir metafile
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'eval { maniadd({q{META.yml} => q{Module meta-data (added by MakeMaker)}}) } ' \
	  -e '    or print "Could not add META.yml to MANIFEST: $${'\''@'\''}\n"' --



# --- MakeMaker distsignature section:
distsignature : create_distdir
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'eval { maniadd({q{SIGNATURE} => q{Public-key signature (added by MakeMaker)}}) } ' \
	  -e '    or print "Could not add SIGNATURE to MANIFEST: $${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(TOUCH) SIGNATURE
	cd $(DISTVNAME) && cpansign -s



# --- MakeMaker install section:

install :: all pure_install doc_install
	$(NOECHO) $(NOOP)

install_perl :: all pure_perl_install doc_perl_install
	$(NOECHO) $(NOOP)

install_site :: all pure_site_install doc_site_install
	$(NOECHO) $(NOOP)

install_vendor :: all pure_vendor_install doc_vendor_install
	$(NOECHO) $(NOOP)

pure_install :: pure_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

doc_install :: doc_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

pure__install : pure_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

doc__install : doc_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_perl_install ::
	$(NOECHO) $(MOD_INSTALL) \
		read $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLARCHLIB)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLPRIVLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLARCHLIB) \
		$(INST_BIN) $(DESTINSTALLBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(SITEARCHEXP)/auto/$(FULLEXT)


pure_site_install ::
	$(NOECHO) $(MOD_INSTALL) \
		read $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLSITEARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLSITELIB) \
		$(INST_ARCHLIB) $(DESTINSTALLSITEARCH) \
		$(INST_BIN) $(DESTINSTALLSITEBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSITESCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLSITEMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLSITEMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(PERL_ARCHLIB)/auto/$(FULLEXT)

pure_vendor_install ::
	$(NOECHO) $(MOD_INSTALL) \
		read $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLVENDORARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLVENDORLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLVENDORARCH) \
		$(INST_BIN) $(DESTINSTALLVENDORBIN) \
		$(INST_SCRIPT) $(DESTINSTALLVENDORSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLVENDORMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLVENDORMAN3DIR)

doc_perl_install ::
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLPRIVLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_site_install ::
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLSITELIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_vendor_install ::
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLVENDORLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod


uninstall :: uninstall_from_$(INSTALLDIRS)dirs
	$(NOECHO) $(NOOP)

uninstall_from_perldirs ::
	$(NOECHO) $(UNINSTALL) $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist

uninstall_from_sitedirs ::
	$(NOECHO) $(UNINSTALL) $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist

uninstall_from_vendordirs ::
	$(NOECHO) $(UNINSTALL) $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist

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



# --- MakeMaker force section:
# Phony target to force checking subdirectories.
FORCE :
	$(NOECHO) $(NOOP)


# --- MakeMaker perldepend section:


# --- MakeMaker makefile section:
# We take a very conservative approach here, but it's worth it.
# We move Makefile to Makefile.old here to avoid gnu make looping.
$(FIRST_MAKEFILE) : Makefile.PL $(CONFIGDEP)
	$(NOECHO) $(ECHO) "Makefile out-of-date with respect to $?"
	$(NOECHO) $(ECHO) "Cleaning current config before rebuilding Makefile..."
	-$(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	-$(NOECHO) $(MV)   $(FIRST_MAKEFILE) $(MAKEFILE_OLD)
	- $(MAKE) $(USEMAKEFILE) $(MAKEFILE_OLD) clean $(DEV_NULL)
	$(PERLRUN) Makefile.PL 
	$(NOECHO) $(ECHO) "==> Your Makefile has been rebuilt. <=="
	$(NOECHO) $(ECHO) "==> Please rerun the $(MAKE) command.  <=="
	false



# --- MakeMaker staticmake section:

# --- MakeMaker makeaperl section ---
MAP_TARGET    = perl
FULLPERL      = /opt/local/bin/perl

$(MAP_TARGET) :: static $(MAKE_APERL_FILE)
	$(MAKE) $(USEMAKEFILE) $(MAKE_APERL_FILE) $@

$(MAKE_APERL_FILE) : $(FIRST_MAKEFILE) pm_to_blib
	$(NOECHO) $(ECHO) Writing \"$(MAKE_APERL_FILE)\" for this $(MAP_TARGET)
	$(NOECHO) $(PERLRUNINST) \
		Makefile.PL DIR= \
		MAKEFILE=$(MAKE_APERL_FILE) LINKTYPE=static \
		MAKEAPERL=1 NORECURS=1 CCCDLFLAGS=


# --- MakeMaker test section:

TEST_VERBOSE=0
TEST_TYPE=test_$(LINKTYPE)
TEST_FILE = test.pl
TEST_FILES = t/*.t
TESTDB_SW = -d

testdb :: testdb_$(LINKTYPE)

test :: $(TEST_TYPE) subdirs-test

subdirs-test ::
	$(NOECHO) $(NOOP)


test_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) "-MExtUtils::Command::MM" "-e" "test_harness($(TEST_VERBOSE), '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)

testdb_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) $(TESTDB_SW) "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)

test_ : test_dynamic

test_static :: test_dynamic
testdb_static :: testdb_dynamic


# --- MakeMaker ppd section:
# Creates a PPD (Perl Package Description) for a binary distribution.
ppd :
	$(NOECHO) $(ECHO) '<SOFTPKG NAME="$(DISTNAME)" VERSION="0,09,0,0">' > $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <TITLE>$(DISTNAME)</TITLE>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <ABSTRACT>Perl extension for Net grid system</ABSTRACT>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <AUTHOR>Charles Woerner &lt;charleswoerner@gmail.com&gt;</AUTHOR>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="DBD-mysql" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="DBI" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="File-Spec" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="Getopt-Long" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="HTML-Parser" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="HTTP-Request" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="IO-Handle" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="IPC-SysV" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="LWP-UserAgent" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="Mail-RFC822-Address" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="Net-DNS" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="Net-SMTP" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="POSIX" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="Socket" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="Sys-Hostname" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="Text-CSV_XS" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="URI" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <OS NAME="$(OSNAME)" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <ARCHITECTURE NAME="darwin-2level-5.8" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <CODEBASE HREF="" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    </IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '</SOFTPKG>' >> $(DISTNAME).ppd


# --- MakeMaker pm_to_blib section:

pm_to_blib : $(TO_INST_PM)
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', '\''$(PM_FILTER)'\'')' -- \
	  lib/Net/SimpleGrid/Scheduler/PartitionedStrategy.pm blib/lib/Net/SimpleGrid/Scheduler/PartitionedStrategy.pm \
	  lib/Net/SimpleGrid/Writer/DBWriter.pm blib/lib/Net/SimpleGrid/Writer/DBWriter.pm \
	  lib/Net/SimpleGrid/Manager.pm blib/lib/Net/SimpleGrid/Manager.pm \
	  lib/Net/SimpleGrid/Scheduler/RoundRobinStrategy.pm blib/lib/Net/SimpleGrid/Scheduler/RoundRobinStrategy.pm \
	  lib/Net/SimpleGrid/Task.pm blib/lib/Net/SimpleGrid/Task.pm \
	  lib/Net/SimpleGrid/Writer.pm blib/lib/Net/SimpleGrid/Writer.pm \
	  lib/Net/SimpleGrid/States.pm blib/lib/Net/SimpleGrid/States.pm \
	  lib/Net/SimpleGrid/Slave.pm blib/lib/Net/SimpleGrid/Slave.pm \
	  lib/Net/SimpleGrid/Writer/CSVWriter.pm blib/lib/Net/SimpleGrid/Writer/CSVWriter.pm \
	  lib/Net/SimpleGrid/ProcessScheduler/PartitionedStrategy.pm blib/lib/Net/SimpleGrid/ProcessScheduler/PartitionedStrategy.pm \
	  lib/Net/SimpleGrid/Task/CompanyDescriptionTask.pm blib/lib/Net/SimpleGrid/Task/CompanyDescriptionTask.pm \
	  lib/Net/SimpleGrid/ProcessScheduler/RoundRobinStrategy.pm blib/lib/Net/SimpleGrid/ProcessScheduler/RoundRobinStrategy.pm \
	  lib/Net/SimpleGrid/Scheduler.pm blib/lib/Net/SimpleGrid/Scheduler.pm \
	  lib/Net/SimpleGrid/Scheduler/PartitionedStrategy/ByEmailDomain.pm blib/lib/Net/SimpleGrid/Scheduler/PartitionedStrategy/ByEmailDomain.pm \
	  lib/Net/SimpleGrid.pm blib/lib/Net/SimpleGrid.pm \
	  lib/Net/SimpleGrid/ProcessScheduler.pm blib/lib/Net/SimpleGrid/ProcessScheduler.pm \
	  lib/Net/SimpleGrid/Task/EmailValidationTask.pm blib/lib/Net/SimpleGrid/Task/EmailValidationTask.pm \
	  lib/Net/SimpleGrid/Node.pm blib/lib/Net/SimpleGrid/Node.pm 
	$(NOECHO) $(TOUCH) pm_to_blib


# --- MakeMaker selfdocument section:


# --- MakeMaker postamble section:


# End.
