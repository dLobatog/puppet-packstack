# == Class: packstack
#
# This module only installs packstack, and the packstack repo, no parameters, no frills.
#
# === Examples
#
#  class { packstack:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Daniel Lobato Garcia <elobatocs@gmail.com>
#
# === Copyright
#
# Copyright 2014 Daniel Lobato Garcia, Apache 2.0 license
#
class packstack {
  wget::fetch { "rdo-repo":
    source      => 'https://rdo.fedorapeople.org/rdo-release.rpm',
    destination => '/opt/rdo-release.rpm',
    timeout     => 0,
    verbose     => false,
  }

  package { 'rdo-release':
    provider => 'rpm',
    source   => '/opt/rdo-release.rpm',
    require  => Wget::Fetch["rdo-repo"],
  }

  package { "openstack-packstack":
    ensure  => "present",
    name    => "openstack-packstack",
    require => Package['rdo-release'],
  }

  exec { "packstack":
    command => "packstack --allinone",
    path    => "/usr/local/bin/:/bin/",
    require => Package["openstack-packstack"]
  }
}
