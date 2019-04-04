################################################################################
#
# knot-netsetup
#
################################################################################

KNOT_NETSETUP_VERSION = 8f27cada2f72dc966554950abc3fb99a9d9e7c2a
KNOT_NETSETUP_SITE = https://github.com/CESARBR/knot-gateway-netsetup.git
KNOT_NETSETUP_SITE_METHOD = git
KNOT_NETSETUP_SETUP_TYPE = setuptools

$(eval $(python-package))