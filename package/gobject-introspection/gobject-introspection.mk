################################################################################
#
# gobject-introspection
#
################################################################################

GOBJECT_INTROSPECTION_VERSION_MAJOR = 1.56
GOBJECT_INTROSPECTION_VERSION = $(GOBJECT_INTROSPECTION_VERSION_MAJOR).1
GOBJECT_INTROSPECTION_SITE = http://ftp.gnome.org/pub/GNOME/sources/gobject-introspection/$(GOBJECT_INTROSPECTION_VERSION_MAJOR)
GOBJECT_INTROSPECTION_SOURCE = gobject-introspection-$(GOBJECT_INTROSPECTION_VERSION).tar.xz
GOBJECT_INTROSPECTION_INSTALL_STAGING = YES
GOBJECT_INTROSPECTION_AUTORECONF = YES
GOBJECT_INTROSPECTION_LICENSE = LGPL-2.0+ or GPL-2.0+
GOBJECT_INTROSPECTION_LICENSE_FILES = COPYING.LGPL COPYING.GPL

GOBJECT_INTROSPECTION_DEPENDENCIES = \
	host-gobject-introspection \
	host-prelink-cross \
	host-qemu \
	libffi \
	libglib2 \
	zlib

HOST_GOBJECT_INTROSPECTION_DEPENDENCIES = \
	host-bison \
	host-flex \
	host-libglib2

# Use the host gi-scanner to prevent the scanner from generating incorrect
# elf classes.
GOBJECT_INTROSPECTION_CONF_OPTS = \
	--enable-host-gi \
	--enable-gi-cross-wrapper=$(STAGING_DIR)/usr/bin/g-ir-scanner-qemuwrapper \
	--enable-gi-ldd-wrapper=$(STAGING_DIR)/usr/bin/g-ir-scanner-lddwrapper \
	--enable-introspection-data

ifeq ($(BR2_PACKAGE_CAIRO),y)
GOBJECT_INTROSPECTION_DEPENDENCIES += cairo
GOBJECT_INTROSPECTION_CONF_OPTS += --with-cairo
endif

ifeq ($(BR2_PACKAGE_PYTHON),y)
GOBJECT_INTROSPECTION_DEPENDENCIES += python
HOST_GOBJECT_INTROSPECTION_DEPENDENCIES += host-python
GOBJECT_INTROSPECTION_PYTHON_PATH = $(STAGING_DIR)/usr/bin/python2
else
GOBJECT_INTROSPECTION_DEPENDENCIES += python3
HOST_GOBJECT_INTROSPECTION_DEPENDENCIES += host-python3
GOBJECT_INTROSPECTION_PYTHON_PATH = $(STAGING_DIR)/usr/bin/python3
endif

# GI_SCANNER_DISABLE_CACHE=1 prevents g-ir-scanner from writing cache data to $HOME
HOST_GOBJECT_INTROSPECTION_CONF_ENV = \
	GI_SCANNER_DISABLE_CACHE=1

# GI_SCANNER_DISABLE_CACHE=1 prevents g-ir-scanner from writing cache data to $HOME
GOBJECT_INTROSPECTION_CONF_ENV = \
	GI_SCANNER_DISABLE_CACHE=1 \
	PYTHON_CONFIG="$(GOBJECT_INTROSPECTION_PYTHON_PATH)-config"

# Make sure g-ir-tool-template uses the host python.
define GOBJECT_INTROSPECTION_FIX_TOOLTEMPLATE_PYTHON_PATH
	sed -i -e '1s|#!.*|#!$(HOST_DIR)/bin/python|' $(@D)/tools/g-ir-tool-template.in
endef
GOBJECT_INTROSPECTION_PRE_CONFIGURE_HOOKS += GOBJECT_INTROSPECTION_FIX_TOOLTEMPLATE_PYTHON_PATH
HOST_GOBJECT_INTROSPECTION_PRE_CONFIGURE_HOOKS += GOBJECT_INTROSPECTION_FIX_TOOLTEMPLATE_PYTHON_PATH

# These wrappers allow gobject-introspection to build the internal introspection
# libraries during the build process.
define GOBJECT_INTROSPECTION_INSTALL_PRE_WRAPPERS
	$(INSTALL) -D -m 755 package/gobject-introspection/g-ir-scanner-lddwrapper.in \
		$(STAGING_DIR)/usr/bin/g-ir-scanner-lddwrapper
	$(INSTALL) -D -m 755 package/gobject-introspection/g-ir-scanner-qemuwrapper.in \
		$(STAGING_DIR)/usr/bin/g-ir-scanner-qemuwrapper
	$(SED) "s|@QEMU_USER@|$(QEMU_USER)|g" \
		$(STAGING_DIR)/usr/bin/g-ir-scanner-qemuwrapper
	$(SED) "s|@TOOLCHAIN_HEADERS_VERSION@|$(BR2_TOOLCHAIN_HEADERS_AT_LEAST)|g" \
		$(STAGING_DIR)/usr/bin/g-ir-scanner-qemuwrapper
	# Use a modules directory which does not exist so we don't load random things
	# which may then get deleted (or their dependencies) and potentially segfault
	mkdir -p $(STAGING_DIR)/usr/lib/gio/modules-dummy
endef
GOBJECT_INTROSPECTION_POST_PATCH_HOOKS += GOBJECT_INTROSPECTION_INSTALL_PRE_WRAPPERS

# Move the real compiler and scanner to .real, and replace them with the wrappers.
define GOBJECT_INTROSPECTION_INSTALL_WRAPPERS
	# Move the real binaries to their names.real, then replace them with
	# the wrappers.
	$(foreach w,g-ir-compiler g-ir-scanner,
		mv $(STAGING_DIR)/usr/bin/$(w) $(STAGING_DIR)/usr/bin/$(w).real
		$(INSTALL) -D -m 755 \
			package/gobject-introspection/$(w).in $(STAGING_DIR)/usr/bin/$(w)
	)
	$(SED) "s|toolsdir=.*|toolsdir=$(STAGING_DIR)/usr/bin|g" \
		$(STAGING_DIR)/usr/lib/pkgconfig/gobject-introspection-1.0.pc
endef
GOBJECT_INTROSPECTION_POST_INSTALL_STAGING_HOOKS += GOBJECT_INTROSPECTION_INSTALL_WRAPPERS

# Only .typelib files are needed to run.
define GOBJECT_INTROSPECTION_REMOVE_DEVELOPMENT_FILES
	find $(TARGET_DIR)/usr/share/ -name '*.gir' -print0 | xargs -0 rm -f
	find $(TARGET_DIR)/usr/share/ -name '*.rnc' -print0 | xargs -0 rm -f
endef
GOBJECT_INTROSPECTION_TARGET_FINALIZE_HOOKS += GOBJECT_INTROSPECTION_REMOVE_DEVELOPMENT_FILES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
