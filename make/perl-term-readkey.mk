###########################################################
#
# perl-term-readkey
#
###########################################################

PERL-TERM-READKEY_SITE=http://search.cpan.org/CPAN/authors/id/J/JS/JSTOWE
PERL-TERM-READKEY_VERSION=2.30
PERL-TERM-READKEY_SOURCE=TermReadKey-$(PERL-TERM-READKEY_VERSION).tar.gz
PERL-TERM-READKEY_DIR=TermReadKey-$(PERL-TERM-READKEY_VERSION)
PERL-TERM-READKEY_UNZIP=zcat

PERL-TERM-READKEY_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PERL-TERM-READKEY_DESCRIPTION=A perl module for simple terminal control
PERL-TERM-READKEY_SECTION=util
PERL-TERM-READKEY_PRIORITY=optional
PERL-TERM-READKEY_DEPENDS=perl

PERL-TERM-READKEY_IPK_VERSION=2

PERL-TERM-READKEY_CONFFILES=

PERL-TERM-READKEY_PATCHES=

PERL-TERM-READKEY_BUILD_DIR=$(BUILD_DIR)/perl-term-readkey
PERL-TERM-READKEY_SOURCE_DIR=$(SOURCE_DIR)/perl-term-readkey
PERL-TERM-READKEY_IPK_DIR=$(BUILD_DIR)/perl-term-readkey-$(PERL-TERM-READKEY_VERSION)-ipk
PERL-TERM-READKEY_IPK=$(BUILD_DIR)/perl-term-readkey_$(PERL-TERM-READKEY_VERSION)-$(PERL-TERM-READKEY_IPK_VERSION)_$(TARGET_ARCH).ipk

PERL-TERM-READKEY_BUILD_DIR=$(BUILD_DIR)/perl-term-readkey
PERL-TERM-READKEY_SOURCE_DIR=$(SOURCE_DIR)/perl-term-readkey
PERL-TERM-READKEY_IPK_DIR=$(BUILD_DIR)/perl-term-readkey-$(PERL-TERM-READKEY_VERSION)-ipk
PERL-TERM-READKEY_IPK=$(BUILD_DIR)/perl-term-readkey_$(PERL-TERM-READKEY_VERSION)-$(PERL-TERM-READKEY_IPK_VERSION)_$(TARGET_ARCH).ipk

$(DL_DIR)/$(PERL-TERM-READKEY_SOURCE):
	$(WGET) -P $(DL_DIR) $(PERL-TERM-READKEY_SITE)/$(PERL-TERM-READKEY_SOURCE)

perl-term-readkey-source: $(DL_DIR)/$(PERL-TERM-READKEY_SOURCE) $(PERL-TERM-READKEY_PATCHES)

$(PERL-TERM-READKEY_BUILD_DIR)/.configured: $(DL_DIR)/$(PERL-TERM-READKEY_SOURCE) $(PERL-TERM-READKEY_PATCHES)
	$(MAKE) perl-stage
	rm -rf $(BUILD_DIR)/$(PERL-TERM-READKEY_DIR) $(PERL-TERM-READKEY_BUILD_DIR)
	$(PERL-TERM-READKEY_UNZIP) $(DL_DIR)/$(PERL-TERM-READKEY_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(PERL-TERM-READKEY_PATCHES) | patch -d $(BUILD_DIR)/$(PERL-TERM-READKEY_DIR) -p1
	mv $(BUILD_DIR)/$(PERL-TERM-READKEY_DIR) $(PERL-TERM-READKEY_BUILD_DIR)
	(cd $(PERL-TERM-READKEY_BUILD_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		LD=$(TARGET_CC) \
		CPPFLAGS="$(STAGING_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS)" \
		PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl" \
		$(PERL_HOSTPERL) Makefile.PL \
		PREFIX=/opt \
	)
	touch $(PERL-TERM-READKEY_BUILD_DIR)/.configured

perl-term-readkey-unpack: $(PERL-TERM-READKEY_BUILD_DIR)/.configured

$(PERL-TERM-READKEY_BUILD_DIR)/.built: $(PERL-TERM-READKEY_BUILD_DIR)/.configured
	rm -f $(PERL-TERM-READKEY_BUILD_DIR)/.built
	$(MAKE) -C $(PERL-TERM-READKEY_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		LD=$(TARGET_CC) \
		CPPFLAGS="$(STAGING_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS)" \
		$(PERL_INC) \
	PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl"
	touch $(PERL-TERM-READKEY_BUILD_DIR)/.built

perl-term-readkey: $(PERL-TERM-READKEY_BUILD_DIR)/.built

$(PERL-TERM-READKEY_BUILD_DIR)/.staged: $(PERL-TERM-READKEY_BUILD_DIR)/.built
	rm -f $(PERL-TERM-READKEY_BUILD_DIR)/.staged
	$(MAKE) -C $(PERL-TERM-READKEY_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
	touch $(PERL-TERM-READKEY_BUILD_DIR)/.staged

perl-term-readkey-stage: $(PERL-TERM-READKEY_BUILD_DIR)/.staged

$(PERL-TERM-READKEY_IPK_DIR)/CONTROL/control:
	@install -d $(PERL-TERM-READKEY_IPK_DIR)/CONTROL
	@rm -f $@
	@echo "Package: perl-term-readkey" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PERL-TERM-READKEY_PRIORITY)" >>$@
	@echo "Section: $(PERL-TERM-READKEY_SECTION)" >>$@
	@echo "Version: $(PERL-TERM-READKEY_VERSION)-$(PERL-TERM-READKEY_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PERL-TERM-READKEY_MAINTAINER)" >>$@
	@echo "Source: $(PERL-TERM-READKEY_SITE)/$(PERL-TERM-READKEY_SOURCE)" >>$@
	@echo "Description: $(PERL-TERM-READKEY_DESCRIPTION)" >>$@
	@echo "Depends: $(PERL-TERM-READKEY_DEPENDS)" >>$@

$(PERL-TERM-READKEY_IPK): $(PERL-TERM-READKEY_BUILD_DIR)/.built
	rm -rf $(PERL-TERM-READKEY_IPK_DIR) $(BUILD_DIR)/perl-term-readkey_*_$(TARGET_ARCH).ipk
	$(MAKE) -C $(PERL-TERM-READKEY_BUILD_DIR) DESTDIR=$(PERL-TERM-READKEY_IPK_DIR) install
	find $(PERL-TERM-READKEY_IPK_DIR)/opt -name 'perllocal.pod' -exec rm -f {} \;
	(cd $(PERL-TERM-READKEY_IPK_DIR)/opt/lib/perl5 ; \
		find . -name '*.so' -exec chmod +w {} \; ; \
		find . -name '*.so' -exec $(STRIP_COMMAND) {} \; ; \
		find . -name '*.so' -exec chmod -w {} \; ; \
	)
	find $(PERL-TERM-READKEY_IPK_DIR)/opt -type d -exec chmod go+rx {} \;
	$(MAKE) $(PERL-TERM-READKEY_IPK_DIR)/CONTROL/control
#	install -m 755 $(PERL-TERM-READKEY_SOURCE_DIR)/postinst $(PERL-TERM-READKEY_IPK_DIR)/CONTROL/postinst
#	install -m 755 $(PERL-TERM-READKEY_SOURCE_DIR)/prerm $(PERL-TERM-READKEY_IPK_DIR)/CONTROL/prerm
	echo $(PERL-TERM-READKEY_CONFFILES) | sed -e 's/ /\n/g' > $(PERL-TERM-READKEY_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PERL-TERM-READKEY_IPK_DIR)

perl-term-readkey-ipk: $(PERL-TERM-READKEY_IPK)

perl-term-readkey-clean:
	-$(MAKE) -C $(PERL-TERM-READKEY_BUILD_DIR) clean

perl-term-readkey-dirclean:
	rm -rf $(BUILD_DIR)/$(PERL-TERM-READKEY_DIR) $(PERL-TERM-READKEY_BUILD_DIR) $(PERL-TERM-READKEY_IPK_DIR) $(PERL-TERM-READKEY_IPK)
