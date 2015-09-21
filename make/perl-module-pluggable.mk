###########################################################
#
# perl-module-pluggable
#
###########################################################

PERL-MODULE-PLUGGABLE_SITE=http://search.cpan.org/CPAN/authors/id/S/SI/SIMONW
PERL-MODULE-PLUGGABLE_VERSION=3.8
PERL-MODULE-PLUGGABLE_SOURCE=Module-Pluggable-$(PERL-MODULE-PLUGGABLE_VERSION).tar.gz
PERL-MODULE-PLUGGABLE_DIR=Module-Pluggable-$(PERL-MODULE-PLUGGABLE_VERSION)
PERL-MODULE-PLUGGABLE_UNZIP=zcat
PERL-MODULE-PLUGGABLE_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PERL-MODULE-PLUGGABLE_DESCRIPTION=Automatically give your module the ability to have plugins.
PERL-MODULE-PLUGGABLE_SECTION=email
PERL-MODULE-PLUGGABLE_PRIORITY=optional
PERL-MODULE-PLUGGABLE_DEPENDS=perl
PERL-MODULE-PLUGGABLE_SUGGESTS=
PERL-MODULE-PLUGGABLE_CONFLICTS=

PERL-MODULE-PLUGGABLE_IPK_VERSION=1

PERL-MODULE-PLUGGABLE_CONFFILES=

PERL-MODULE-PLUGGABLE_BUILD_DIR=$(BUILD_DIR)/perl-module-pluggable
PERL-MODULE-PLUGGABLE_SOURCE_DIR=$(SOURCE_DIR)/perl-module-pluggable
PERL-MODULE-PLUGGABLE_IPK_DIR=$(BUILD_DIR)/perl-module-pluggable-$(PERL-MODULE-PLUGGABLE_VERSION)-ipk
PERL-MODULE-PLUGGABLE_IPK=$(BUILD_DIR)/perl-module-pluggable_$(PERL-MODULE-PLUGGABLE_VERSION)-$(PERL-MODULE-PLUGGABLE_IPK_VERSION)_$(TARGET_ARCH).ipk

$(DL_DIR)/$(PERL-MODULE-PLUGGABLE_SOURCE):
	$(WGET) -P $(@D) $(PERL-MODULE-PLUGGABLE_SITE)/$(@F) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

perl-module-pluggable-source: $(DL_DIR)/$(PERL-MODULE-PLUGGABLE_SOURCE) $(PERL-MODULE-PLUGGABLE_PATCHES)

$(PERL-MODULE-PLUGGABLE_BUILD_DIR)/.configured: $(DL_DIR)/$(PERL-MODULE-PLUGGABLE_SOURCE) $(PERL-MODULE-PLUGGABLE_PATCHES) make/perl-module-pluggable.mk
	rm -rf $(BUILD_DIR)/$(PERL-MODULE-PLUGGABLE_DIR) $(@D)
	$(PERL-MODULE-PLUGGABLE_UNZIP) $(DL_DIR)/$(PERL-MODULE-PLUGGABLE_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(PERL-MODULE-PLUGGABLE_PATCHES) | patch -d $(BUILD_DIR)/$(PERL-MODULE-PLUGGABLE_DIR) -p1
	mv $(BUILD_DIR)/$(PERL-MODULE-PLUGGABLE_DIR) $(@D)
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS)" \
		PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl" \
		$(PERL_HOSTPERL) Makefile.PL \
		PREFIX=/opt \
	)
	touch $@

perl-module-pluggable-unpack: $(PERL-MODULE-PLUGGABLE_BUILD_DIR)/.configured

$(PERL-MODULE-PLUGGABLE_BUILD_DIR)/.built: $(PERL-MODULE-PLUGGABLE_BUILD_DIR)/.configured
	rm -f $@
	$(MAKE) -C $(@D) \
	PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl"
	touch $@

perl-module-pluggable: $(PERL-MODULE-PLUGGABLE_BUILD_DIR)/.built

$(PERL-MODULE-PLUGGABLE_BUILD_DIR)/.staged: $(PERL-MODULE-PLUGGABLE_BUILD_DIR)/.built
	rm -f $@
	$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
	touch $@

perl-module-pluggable-stage: $(PERL-MODULE-PLUGGABLE_BUILD_DIR)/.staged

$(PERL-MODULE-PLUGGABLE_IPK_DIR)/CONTROL/control:
	@install -d $(@D)
	@rm -f $@
	@echo "Package: perl-module-pluggable" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PERL-MODULE-PLUGGABLE_PRIORITY)" >>$@
	@echo "Section: $(PERL-MODULE-PLUGGABLE_SECTION)" >>$@
	@echo "Version: $(PERL-MODULE-PLUGGABLE_VERSION)-$(PERL-MODULE-PLUGGABLE_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PERL-MODULE-PLUGGABLE_MAINTAINER)" >>$@
	@echo "Source: $(PERL-MODULE-PLUGGABLE_SITE)/$(PERL-MODULE-PLUGGABLE_SOURCE)" >>$@
	@echo "Description: $(PERL-MODULE-PLUGGABLE_DESCRIPTION)" >>$@
	@echo "Depends: $(PERL-MODULE-PLUGGABLE_DEPENDS)" >>$@
	@echo "Suggests: $(PERL-MODULE-PLUGGABLE_SUGGESTS)" >>$@
	@echo "Conflicts: $(PERL-MODULE-PLUGGABLE_CONFLICTS)" >>$@

$(PERL-MODULE-PLUGGABLE_IPK): $(PERL-MODULE-PLUGGABLE_BUILD_DIR)/.built
	rm -rf $(PERL-MODULE-PLUGGABLE_IPK_DIR) $(BUILD_DIR)/perl-module-pluggable_*_$(TARGET_ARCH).ipk
	$(MAKE) -C $(PERL-MODULE-PLUGGABLE_BUILD_DIR) DESTDIR=$(PERL-MODULE-PLUGGABLE_IPK_DIR) install
	find $(PERL-MODULE-PLUGGABLE_IPK_DIR)/opt -name 'perllocal.pod' -exec rm -f {} \;
	$(MAKE) $(PERL-MODULE-PLUGGABLE_IPK_DIR)/CONTROL/control
	echo $(PERL-MODULE-PLUGGABLE_CONFFILES) | sed -e 's/ /\n/g' > $(PERL-MODULE-PLUGGABLE_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PERL-MODULE-PLUGGABLE_IPK_DIR)

perl-module-pluggable-ipk: $(PERL-MODULE-PLUGGABLE_IPK)

perl-module-pluggable-clean:
	-$(MAKE) -C $(PERL-MODULE-PLUGGABLE_BUILD_DIR) clean

perl-module-pluggable-dirclean:
	rm -rf $(BUILD_DIR)/$(PERL-MODULE-PLUGGABLE_DIR) $(PERL-MODULE-PLUGGABLE_BUILD_DIR) $(PERL-MODULE-PLUGGABLE_IPK_DIR) $(PERL-MODULE-PLUGGABLE_IPK)
