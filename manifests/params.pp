#
# == Class: hwraid::params
#
# Defines some variables based on the operating system
#
class hwraid::params {

    include ::os::params

    case $::osfamily {
        'Debian': {
            # Generic settings
            $pid_dir = '/var/run'

            # Adaptec AAC RAID controllers
            $aacraid_package_name = 'aacraid-status'
            $aacraid_service_name = 'aacraid-statusd'
            $aacraid_statusd_pidfile = "${pid_dir}/${aacraid_service_name}.pid"

            # 3Ware Inc 9000 series RAID controllers
            $twcli_package_name = 'tw-cli'
            $ware_status_package_name = '3ware-status'
            $ware_service_name = '3ware-statusd'
            $ware_statusd_pidfile = "${pid_dir}/${ware_service_name}.pid"

            # MegaRAID SAS RAID controllers
            $megacli_package_name = 'megacli'
            $megaclisas_status_package_name = 'megaclisas-status'
            $megaclisas_service_name = 'megaclisas-statusd'
            $megaclisas_statusd_pidfile = "${pid_dir}/${megaclisas_service_name}.pid"
        }
        default: {
            fail("Unsupported OS: ${::osfamily}")
        }
    }

    if $::systemd {
        $aacraid_service_start = "${::os::params::systemctl} start ${aacraid_service_name}"
        $aacraid_service_stop = "${::os::params::systemctl} stop ${aacraid_service_name}"
        $ware_service_start = "${::os::params::systemctl} start ${ware_service_name}"
        $ware_service_stop = "${::os::params::systemctl} stop ${ware_service_name}"
        $megaclisas_service_start = "${::os::params::systemctl} start ${megaclisas_service_name}"
        $megaclisas_service_stop = "${::os::params::systemctl} stop ${megaclisas_service_name}"
    } else {
        $aacraid_service_start = "${::os::params::service_cmd} ${aacraid_service_name} start"
        $aacraid_service_stop = "${::os::params::service_cmd} ${aacraid_service_name} stop"
        $ware_service_start = "${::os::params::service_cmd} ${ware_service_name} start"
        $ware_service_stop = "${::os::params::service_cmd} ${ware_service_name} stop"
        $megaclisas_service_start = "${::os::params::service_cmd} ${megaclisas_service_name} start"
        $megaclisas_service_stop = "${::os::params::service_cmd} ${megaclisas_service_name} stop"
    }
}
