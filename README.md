# hwraid

A Puppet module for managing common tasks for hardware RAID.

# Module usage

This module provides these classes:

* [Class: hwraid](manifests/init.pp)
* [Class: hwraid::aac](manifests/aac.pp)

There are also a few custom facts:

* [Fact: has_aacraid](lib/facter/has_aacraid.rb)
* [Fact: hwraid_type](lib/facter/hwraid_type.rb)

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Ubuntu 14.04

Any Debian derivative should be straightforward to port to.

For details see [params.pp](manifests/params.pp).
