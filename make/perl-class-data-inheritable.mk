###########################################################
#
# perl-class-data-inheritable
#
###########################################################
PERL-CLASS-DATA-INHERITABLE_SITE=http://search.cpan.org/CPAN/authors/id/T/TM/TMTM
PERL-CLASS-DATA-INHERITABLE_VERSION=0.04
PERL-CLASS-DATA-INHERITABLE_SOURCE=Class-Data-Inheritable-$(PERL-CLASS-DATA-INHERITABLE_VERSION).tar.gz
PERL-CLASS-DATA-INHERITABLE_DIR=Class-Data-Inheritable-$(PERL-CLASS-DATA-INHERITABLE_VERSION)
PERL-CLASS-DATA-INHERITABLE_UNZIP=zcat
PERL-CLASS-DATA-INHERITABLE_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PERL-CLASS-DATA-INHERITABLE_DESCRIPTION=Class-Data-Inheritable - Inheritable, overridable class data
PERL-CLASS-DATA-INHERITABLE_SECTION=util
PERL-CLASS-DATA-INHERITABLE_PRIORITY=optional
PERL-CLASS-DATA-INHERITABLE_DEPENDS=perl
PERL-CLASS-DATA-INHERITABLE_SUGGESTS=
PERL-CLASS-DATA-INHERITABLE_CONFLICTS=

PERL-CLASS-DATA-INHERITABLE_IPK_VERSION=2

PERL-CLASS-DATA-INHERITABLE_CONFFILES=

PERL-CLASS-DATA-INHERITABLE_BUILD_DIR=$(BUILD_DIR)/perl-class-data-inheritable
PERL-CLASS-DATA-INHERITABLE_SOURCE_DIR=$(SOURCE_DIR)/perl-class-data-inheritable
PERL-CLASS-DATA-INHERITABLE_IPK_DIR=$(BUILD_DIR)/perl-class-data-inheritable-$(PERL-CLASS-DATA-INHERITABLE_VERSION)-ipk
PERL-CLASS-DATA-INHERITABLE_IPK=$(BUILD_DIR)/perl-class-data-inheritable_$(PERL-CLASS-DATA-INHERITABLE_VERSION)-$(PERL-CLASS-DATA-INHERITABLE_IPK_VERSION)_$(TARGET_ARCH).ipk

$(DL_DIR)/$(PERL-CLASS-DATA-INHERITABLE_SOURCE):
	$(WGET) -P $(DL_DIR) $(PERL-CLASS-DATA-INHERITABLE_SITE)/$(PERL-CLASS-DATA-INHERITABLE_SOURCE)

perl-class-data-inheritable-source: $(DL_DIR)/$(PERL-CLASS-DATA-INHERITABLE_SOURCE) $(PERL-CLASS-DATA-INHERITABLE_PATCHES)

$(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)/.configured: $(DL_DIR)/$(PERL-CLASS-DATA-INHERITABLE_SOURCE) $(PERL-CLASS-DATA-INHERITABLE_PATCHES)
	$(MAKE) perl-stage
	rm -rf $(BUILD_DIR)/$(PERL-CLASS-DATA-INHERITABLE_DIR) $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)
	$(PERL-CLASS-DATA-INHERITABLE_UNZIP) $(DL_DIR)/$(PERL-CLASS-DATA-INHERITABLE_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(PERL-CLASS-DATA-INHERITABLE_PATCHES) | patch -d $(BUILD_DIR)/$(PERL-CLASS-DATA-INHERITABLE_DIR) -p1
	mv $(BUILD_DIR)/$(PERL-CLASS-DATA-INHERITABLE_DIR) $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)
	(cd $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS)" \
		PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl" \
		$(PERL_HOSTPERL) Makefile.PL \
		PREFIX=/opt \
	)
	touch $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)/.configured

perl-class-data-inheritable-unpack: $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)/.configured

$(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)/.built: $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)/.configured
	rm -f $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)/.built
	$(MAKE) -C $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR) \
	PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl"
	touch $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)/.built

perl-class-data-inheritable: $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)/.built

$(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)/.staged: $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)/.built
	rm -f $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)/.staged
	$(MAKE) -C $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
	touch $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)/.staged

perl-class-data-inheritable-stage: $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)/.staged

$(PERL-CLASS-DATA-INHERITABLE_IPK_DIR)/CONTROL/control:
	@install -d $(PERL-CLASS-DATA-INHERITABLE_IPK_DIR)/CONTROL
	@rm -f $@
	@echo "Package: perl-class-data-inheritable" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PERL-CLASS-DATA-INHERITABLE_PRIORITY)" >>$@
	@echo "Section: $(PERL-CLASS-DATA-INHERITABLE_SECTION)" >>$@
	@echo "Version: $(PERL-CLASS-DATA-INHERITABLE_VERSION)-$(PERL-CLASS-DATA-INHERITABLE_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PERL-CLASS-DATA-INHERITABLE_MAINTAINER)" >>$@
	@echo "Source: $(PERL-CLASS-DATA-INHERITABLE_SITE)/$(PERL-CLASS-DATA-INHERITABLE_SOURCE)" >>$@
	@echo "Description: $(PERL-CLASS-DATA-INHERITABLE_DESCRIPTION)" >>$@
	@echo "Depends: $(PERL-CLASS-DATA-INHERITABLE_DEPENDS)" >>$@
	@echo "Suggests: $(PERL-CLASS-DATA-INHERITABLE_SUGGESTS)" >>$@
	@echo "Conflicts: $(PERL-CLASS-DATA-INHERITABLE_CONFLICTS)" >>$@

$(PERL-CLASS-DATA-INHERITABLE_IPK): $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR)/.built
	rm -rf $(PERL-CLASS-DATA-INHERITABLE_IPK_DIR) $(BUILD_DIR)/perl-class-data-inheritable_*_$(TARGET_ARCH).ipk
	$(MAKE) -C $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR) DESTDIR=$(PERL-CLASS-DATA-INHERITABLE_IPK_DIR) install
	find $(PERL-CLASS-DATA-INHERITABLE_IPK_DIR)/opt -name 'perllocal.pod' -exec rm -f {} \;
	(cd $(PERL-CLASS-DATA-INHERITABLE_IPK_DIR)/opt/lib/perl5 ; \
		find . -name '*.so' -exec chmod +w {} \; ; \
		find . -name '*.so' -exec $(STRIP_COMMAND) {} \; ; \
		find . -name '*.so' -exec chmod -w {} \; ; \
	)
	find $(PERL-CLASS-DATA-INHERITABLE_IPK_DIR)/opt -type d -exec chmod go+rx {} \;
	$(MAKE) $(PERL-CLASS-DATA-INHERITABLE_IPK_DIR)/CONTROL/control
	echo $(PERL-CLASS-DATA-INHERITABLE_CONFFILES) | sed -e 's/ /\n/g' > $(PERL-CLASS-DATA-INHERITABLE_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PERL-CLASS-DATA-INHERITABLE_IPK_DIR)

perl-class-data-inheritable-ipk: $(PERL-CLASS-DATA-INHERITABLE_IPK)

perl-class-data-inheritable-clean:
	-$(MAKE) -C $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR) clean

perl-class-data-inheritable-dirclean:
	rm -rf $(BUILD_DIR)/$(PERL-CLASS-DATA-INHERITABLE_DIR) $(PERL-CLASS-DATA-INHERITABLE_BUILD_DIR) $(PERL-CLASS-DATA-INHERITABLE_IPK_DIR) $(PERL-CLASS-DATA-INHERITABLE_IPK)
