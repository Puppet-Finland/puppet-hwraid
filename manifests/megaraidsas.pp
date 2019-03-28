#
# == Class: hwraid::megaraidsas
#
# Configure monitoring for MegaRAID SAS series of hardware RAID controllers.
#
# == Parameters
#
# [*ensure*]
#   Status of RAID monitoring. Valid values are 'present' (default) and 
#   'absent'.
# [*manage_monit*]
#   Whether to monitor megaclisas-statusd using monit. Valid values are true 
#   (default) and false.
# [*remind*]
#   How often to send reminder emails (of degraded arrays). Value is given in 
#   seconds and defaults to 86400 (24 hours)
# [*email*]
#   Email address where notification emails are sent. Defaults to top-scope 
#   variable $::servermonitor.
#
class hwraid::megaraidsas
(
    Enum['present','absent'] $ensure = 'present',
    Boolean                  $manage_monit = true,
    Integer                  $remind = 86400,
    String                   $email = $::servermonitor

) inherits hwraid::params
{

    include ::hwraid

    $package_require = $::osfamily ? {
        'Debian' => Class['::hwraid::aptrepo'],
        default  => undef,
    }

    Package {
        ensure  => $ensure,
        require => $package_require,
    }
    package { 'hwraid-megacli':           name => $::hwraid::params::megacli_package_name }
    package { 'hwraid-megaclisas-status': name => $::hwraid::params::megaclisas_status_package_name }

    # On Debian the megaclisas-statusd is configured using a file under 
    # /etc/default.
    if $::osfamily == 'Debian' {
        file { 'hwraid-megaclisas-statusd':
            ensure  => $ensure,
            name    => '/etc/default/megaclisas-statusd',
            content => template('hwraid/megaclisas-statusd.erb'),
            owner   => $::os::params::adminuser,
            group   => $::os::params::admingroup,
            mode    => '0644',
            notify  => Service['hwraid-megaclisas-statusd'],
        }
    }

    $service_enable = $ensure ? {
        'present' => true,
        'absent'  => false,
        default   => undef,
    }

    service { 'hwraid-megaclisas-statusd':
        name    => $::hwraid::params::megaclisas_service_name,
        enable  => $service_enable,
        require => Package['hwraid-megaclisas-status'],
    }

    if $manage_monit {
        @monit::fragment { 'hwraid-megaclisas-statusd.monit':
            basename   => 'megaclisas-statusd',
            modulename => 'hwraid',
            tag        => 'default',
        }
    }
}
