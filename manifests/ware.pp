#
# == Class: hwraid::ware
#
# Configure monitoring for 3Ware Eskaled 9000 series hardware RAID devices. The 
# name of this class is silly, because Puppet does not allow numbers in the 
# namespaces (classes, defines, variables, etc).
#
# == Parameters
#
# [*ensure*]
#   Status of RAID monitoring. Valid values are 'present' (default) and 
#   'absent'.
# [*manage_monit*]
#   Whether to monitor 3ware-statusd using monit. Valid values are true 
#   (default) and false.
# [*remind*]
#   How often to send reminder emails (of degraded arrays). Value is given in 
#   seconds and defaults to 86400 (24 hours)
# [*email*]
#   Email address where notification emails are sent. Defaults to top-scope 
#   variable $::servermonitor.
#
class hwraid::ware
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
    package { 'hwraid-tw-cli':       name => $::hwraid::params::twcli_package_name }
    package { 'hwraid-3ware-status': name => $::hwraid::params::ware_status_package_name }

    # On Debian the 3ware-statusd is configured using a file under 
    # /etc/default.
    if $::osfamily == 'Debian' {
        file { 'hwraid-3ware-statusd':
            ensure  => $ensure,
            name    => '/etc/default/3ware-statusd',
            content => template('hwraid/3ware-statusd.erb'),
            owner   => $::os::params::adminuser,
            group   => $::os::params::admingroup,
            mode    => '0644',
            notify  => Service['hwraid-3ware-statusd'],
        }
    }

    $service_enable = $ensure ? {
        'present' => true,
        'absent'  => false,
        default   => undef,
    }

    service { 'hwraid-3ware-statusd':
        name    => $::hwraid::params::ware_service_name,
        enable  => $service_enable,
        require => Package['hwraid-3ware-status'],
    }

    if $manage_monit {
        monit::fragment { 'hwraid-3ware-statusd.monit':
            basename   => '3ware-statusd',
            modulename => 'hwraid',
        }
    }
}
