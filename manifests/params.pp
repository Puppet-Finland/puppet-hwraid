#
# == Class: hwraid::params
#
# Defines some variables based on the operating system
#
class hwraid::params {

    case $::osfamily {
        'Debian': {
            $aacraid_package_name = 'aacraid-status'
            $aacraid_service_name = 'aacraid-statusd'
        }
        default: {
            fail("Unsupported OS: ${::osfamily}")
        }
    }
}
