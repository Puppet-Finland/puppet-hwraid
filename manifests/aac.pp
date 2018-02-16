#
# == Class: hwraid::aac
#
# Configure monitoring for Adaptec AAC hardware RAID devices
#
# == Parameters
#
# [*ensure*]
#   Status of AAC RAID monitoring. Valid values are 'present' (default) and 
#   'absent'.
# [*manage_monit*]
#   Whether to monitor aacraid-statusd using monit. Valid values are true (default) and
#   false.
# [*remind*]
#   How often to send reminder emails (of degraded arrays). Value is given in 
#   seconds and defaults to 86400 (24 hours)
# [*email*]
#   Email address where notification emails are sent. Defaults to top-scope 
#   variable $::servermonitor.
#
class hwraid::aac
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

    package { 'hwraid-aacraid':
        ensure  => $ensure,
        name    => $::hwraid::params::aacraid_package_name,
        require => $package_require,
    }

    # On Debian the aacraid-statusd is configured using a file under 
    # /etc/default.
    if $::osfamily == 'Debian' {
        file { 'hwraid-aacraid-status':
            ensure  => $ensure,
            name    => '/etc/default/aacraid-statusd',
            content => template('hwraid/aacraid-statusd.erb'),
            owner   => $::os::params::adminuser,
            group   => $::os::params::admingroup,
            mode    => '0644',
            notify  => Service['hwraid-aacraid-statusd'],
        }
    }

    $service_enable = $ensure ? {
        'present' => true,
        'absent'  => false,
        default   => undef,
    }

    service { 'hwraid-aacraid-statusd':
        name    => $::hwraid::params::aacraid_service_name,
        enable  => $service_enable,
        require => Package['hwraid-aacraid'],
    }

    if $manage_monit {
        monit::fragment { 'hwraid-aacraid-statusd.monit':
            basename   => 'aacraid-statusd',
            modulename => 'hwraid',
        }
    }
}
