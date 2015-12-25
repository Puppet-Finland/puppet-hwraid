#
# == Class: hwraid
#
# This class sets up things that are needed to install hardware RAID tools. In 
# practice it sets up apt repositories that contain hardware RAID tools for 
# various RAID controllers.
#
# == Parameters
#
# [*manage*]
#   Whether to manage hardware RAID repository setup using Puppet. Valid values are true 
#   (default) and false.
# [*ensure*]
#   Status of hardware RAID tools. Valid values are 'present' (default) and 
#   'absent'.
#
# == Authors
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class hwraid
(
    $manage = true,
    $ensure = 'present'

) inherits hwraid::params
{

validate_bool($manage)
validate_re("${ensure}", '^(present|absent)$')

if $manage {

    if $::osfamily == 'Debian' {
        class { '::hwraid::aptrepo':
            ensure => $ensure,
        }
    }
}
}
