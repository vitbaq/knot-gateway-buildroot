################################################################################
#
# python-pycairo
#
################################################################################

PYTHON_PYCAIRO_VERSION = 1.18.0
PYTHON_PYCAIRO_SOURCE = pycairo-$(PYTHON_PYCAIRO_VERSION).tar.gz
PYTHON_PYCAIRO_SITE = https://files.pythonhosted.org/packages/a6/54/23d6cf3e8d8f1eb30e0e58f171b6f62b2ea75c024935492373639a1a08e4
PYTHON_PYCAIRO_LICENSE = LGPL-2.1+
PYTHON_PYCAIRO_LICENSE_FILES = COPYING
PYTHON_PYCAIRO_SETUP_TYPE = setuptools

$(eval $(python-package))
