################################################################################
#
# gobject-introspection
#
################################################################################

GOBJECT_INTROSPECTION_VERSION_MAJOR = 1.58
GOBJECT_INTROSPECTION_VERSION = $(GOBJECT_INTROSPECTION_VERSION_MAJOR).3
GOBJECT_INTROSPECTION_SOURCE = gobject-introspection-$(GOBJECT_INTROSPECTION_VERSION).tar.xz
GOBJECT_INTROSPECTION_SITE = https://ftp.gnome.org/pub/gnome/sources/gobject-introspection/$(GOBJECT_INTROSPECTION_VERSION_MAJOR)/
GOBJECT_INTROSPECTION_LICENSE = LGPL-2.1+
GOBJECT_INTROSPECTION_LICENSE_FILES = COPYING
GOBJECT_INTROSPECTION_DEPENDENCIES = libglib2

$(eval $(autotools-package))
