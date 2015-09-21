###########################################################
#
# perl-sys-hostname-long
#
###########################################################

PERL-SYS-HOSTNAME-LONG_SITE=http://search.cpan.org/CPAN/authors/id/S/SC/SCOTT
PERL-SYS-HOSTNAME-LONG_VERSION=1.4
PERL-SYS-HOSTNAME-LONG_SOURCE=Sys-Hostname-Long-$(PERL-SYS-HOSTNAME-LONG_VERSION).tar.gz
PERL-SYS-HOSTNAME-LONG_DIR=Sys-Hostname-Long-$(PERL-SYS-HOSTNAME-LONG_VERSION)
PERL-SYS-HOSTNAME-LONG_UNZIP=zcat
PERL-SYS-HOSTNAME-LONG_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PERL-SYS-HOSTNAME-LONG_DESCRIPTION=Sys-Hostname-Long - Try every conceivable way to get full hostname
PERL-SYS-HOSTNAME-LONG_SECTION=util
PERL-SYS-HOSTNAME-LONG_PRIORITY=optional
PERL-SYS-HOSTNAME-LONG_DEPENDS=perl
PERL-SYS-HOSTNAME-LONG_SUGGESTS=
PERL-SYS-HOSTNAME-LONG_CONFLICTS=

PERL-SYS-HOSTNAME-LONG_IPK_VERSION=1

PERL-SYS-HOSTNAME-LONG_CONFFILES=

PERL-SYS-HOSTNAME-LONG_BUILD_DIR=$(BUILD_DIR)/perl-sys-hostname-long
PERL-SYS-HOSTNAME-LONG_SOURCE_DIR=$(SOURCE_DIR)/perl-sys-hostname-long
PERL-SYS-HOSTNAME-LONG_IPK_DIR=$(BUILD_DIR)/perl-sys-hostname-long-$(PERL-SYS-HOSTNAME-LONG_VERSION)-ipk
PERL-SYS-HOSTNAME-LONG_IPK=$(BUILD_DIR)/perl-sys-hostname-long_$(PERL-SYS-HOSTNAME-LONG_VERSION)-$(PERL-SYS-HOSTNAME-LONG_IPK_VERSION)_$(TARGET_ARCH).ipk

$(DL_DIR)/$(PERL-SYS-HOSTNAME-LONG_SOURCE):
	$(WGET) -P $(DL_DIR) $(PERL-SYS-HOSTNAME-LONG_SITE)/$(PERL-SYS-HOSTNAME-LONG_SOURCE)

perl-sys-hostname-long-source: $(DL_DIR)/$(PERL-SYS-HOSTNAME-LONG_SOURCE) $(PERL-SYS-HOSTNAME-LONG_PATCHES)

$(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)/.configured: $(DL_DIR)/$(PERL-SYS-HOSTNAME-LONG_SOURCE) $(PERL-SYS-HOSTNAME-LONG_PATCHES)
	rm -rf $(BUILD_DIR)/$(PERL-SYS-HOSTNAME-LONG_DIR) $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)
	$(PERL-SYS-HOSTNAME-LONG_UNZIP) $(DL_DIR)/$(PERL-SYS-HOSTNAME-LONG_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(PERL-SYS-HOSTNAME-LONG_PATCHES) | patch -d $(BUILD_DIR)/$(PERL-SYS-HOSTNAME-LONG_DIR) -p1
	mv $(BUILD_DIR)/$(PERL-SYS-HOSTNAME-LONG_DIR) $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)
	(cd $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS)" \
		PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl" \
		$(PERL_HOSTPERL) Makefile.PL \
                $(STAGING_PREFIX) -- \
		PREFIX=/opt \
	)
	touch $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)/.configured

perl-sys-hostname-long-unpack: $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)/.configured

$(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)/.built: $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)/.configured
	rm -f $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)/.built
	$(MAKE) -C $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS)" \
		$(PERL_INC) \
	PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl"
	touch $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)/.built

perl-sys-hostname-long: $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)/.built

$(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)/.staged: $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)/.built
	rm -f $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)/.staged
	$(MAKE) -C $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
	touch $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)/.staged

perl-sys-hostname-long-stage: $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)/.staged

$(PERL-SYS-HOSTNAME-LONG_IPK_DIR)/CONTROL/control:
	@install -d $(PERL-SYS-HOSTNAME-LONG_IPK_DIR)/CONTROL
	@rm -f $@
	@echo "Package: perl-sys-hostname-long" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PERL-SYS-HOSTNAME-LONG_PRIORITY)" >>$@
	@echo "Section: $(PERL-SYS-HOSTNAME-LONG_SECTION)" >>$@
	@echo "Version: $(PERL-SYS-HOSTNAME-LONG_VERSION)-$(PERL-SYS-HOSTNAME-LONG_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PERL-SYS-HOSTNAME-LONG_MAINTAINER)" >>$@
	@echo "Source: $(PERL-SYS-HOSTNAME-LONG_SITE)/$(PERL-SYS-HOSTNAME-LONG_SOURCE)" >>$@
	@echo "Description: $(PERL-SYS-HOSTNAME-LONG_DESCRIPTION)" >>$@
	@echo "Depends: $(PERL-SYS-HOSTNAME-LONG_DEPENDS)" >>$@
	@echo "Suggests: $(PERL-SYS-HOSTNAME-LONG_SUGGESTS)" >>$@
	@echo "Conflicts: $(PERL-SYS-HOSTNAME-LONG_CONFLICTS)" >>$@

$(PERL-SYS-HOSTNAME-LONG_IPK): $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR)/.built
	rm -rf $(PERL-SYS-HOSTNAME-LONG_IPK_DIR) $(BUILD_DIR)/perl-sys-hostname-long_*_$(TARGET_ARCH).ipk
	$(MAKE) -C $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR) DESTDIR=$(PERL-SYS-HOSTNAME-LONG_IPK_DIR) install
	find $(PERL-SYS-HOSTNAME-LONG_IPK_DIR)/opt -name 'perllocal.pod' -exec rm -f {} \;
	(cd $(PERL-SYS-HOSTNAME-LONG_IPK_DIR)/opt/lib/perl5 ; \
		find . -name '*.so' -exec chmod +w {} \; ; \
		find . -name '*.so' -exec $(STRIP_COMMAND) {} \; ; \
		find . -name '*.so' -exec chmod -w {} \; ; \
	)
	find $(PERL-SYS-HOSTNAME-LONG_IPK_DIR)/opt -type d -exec chmod go+rx {} \;
	$(MAKE) $(PERL-SYS-HOSTNAME-LONG_IPK_DIR)/CONTROL/control
	echo $(PERL-SYS-HOSTNAME-LONG_CONFFILES) | sed -e 's/ /\n/g' > $(PERL-SYS-HOSTNAME-LONG_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PERL-SYS-HOSTNAME-LONG_IPK_DIR)

perl-sys-hostname-long-ipk: $(PERL-SYS-HOSTNAME-LONG_IPK)

perl-sys-hostname-long-clean:
	-$(MAKE) -C $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR) clean

perl-sys-hostname-long-dirclean:
	rm -rf $(BUILD_DIR)/$(PERL-SYS-HOSTNAME-LONG_DIR) $(PERL-SYS-HOSTNAME-LONG_BUILD_DIR) $(PERL-SYS-HOSTNAME-LONG_IPK_DIR) $(PERL-SYS-HOSTNAME-LONG_IPK)
