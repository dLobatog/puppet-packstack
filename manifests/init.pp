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
  file { "/opt/rdo-release.rpm": source => "https://rdo.fedorapeople.org/rdo-release.rpm"}

  package { 'rdo-release':
    provider => 'rpm',
    source   => '/opt/rdo-release.rpm',
    require  => File["/opt/rdo-release.rpm"],
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
