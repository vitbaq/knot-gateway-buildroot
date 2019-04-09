################################################################################
#
# python-gobject
#
################################################################################

PYTHON_GOBJECT_VERSION = 3.32.0
PYTHON_GOBJECT_SOURCE = PyGObject-$(PYTHON_GOBJECT_VERSION).tar.gz
PYTHON_GOBJECT_SITE = https://files.pythonhosted.org/packages/0b/fd/56ac6898afc5c7f5718026103bd8f0b44714b6f79ac20d7eb8990c9a7eab
PYTHON_GOBJECT_LICENSE = LGPL-2.1+
PYTHON_GOBJECT_LICENSE_FILES = COPYING
PYTHON_GOBJECT_DEPENDENCIES = host-pkgconf libglib2
PYTHON_GOBJECT_SETUP_TYPE = setuptools

$(eval $(python-package))
