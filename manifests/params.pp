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
            $twcli_package_name = 'tw-cli'
            $ware_status_package_name = '3ware-status'
            $ware_status_service_name = '3ware-statusd'
        }
        default: {
            fail("Unsupported OS: ${::osfamily}")
        }
    }
}
