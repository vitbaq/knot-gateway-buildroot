################################################################################
#
# knot-netsetup
#
################################################################################

KNOT_NETSETUP_VERSION = netsetup_vba_v1
KNOT_NETSETUP_SITE = https://github.com/vitbaq/knot-gateway-netsetup.git
KNOT_NETSETUP_SITE_METHOD = git
KNOT_NETSETUP_SETUP_TYPE = setuptools

$(eval $(python-package))