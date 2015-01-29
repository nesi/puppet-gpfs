# Class: gpfs
#
# This module manages gpfs
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

# This file is part of the gpfs Puppet module.
#
#     The gpfs Puppet module is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     The gpfs Puppet module is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with the gpfs Puppet module.  If not, see <http://www.gnu.org/licenses/>.

# [Remember: No empty lines between comments and class definition]
class gpfs(
  $source_url,
  $version,
  $update,
  $manage_deps = false,
  $kernel_version = $::kernelrelease,
) {

  $base_source   = "${source_url}/gpfs.base-${version}-0.${::architecture}.rpm"
  $update_source = "${source_url}/gpfs.base-${version}-${update}.${::architecture}.update.rpm"
  $ports_source  = "${source_url}/gpfs.gplbin-${kernel_version}-${version}-${update}.${::architecture}.rpm"

  if $manage_deps {
    $gpfs_deps = ['compat-libstdc++-33','libstdc++','rsh','ksh']

    package {$gpfs_deps:
      ensure  => installed,
      before  => Package['gpfs.base'],
    }


    package {"kernel-${kernel_version}":
      ensure => installed,
      before  => Package['gpfs.base'],
    }
  }

  package {"gpfs.base":
    provider  => 'rpm',
    ensure    => installed,
    source    => $base_source,
  }

  # The gpfs.update package conflicts with the gpfs.base package
  # and has to be installed with rpm -Uvh, which the package resource
  # does not (yet) support.
  # package {"gpfs.update":
  #   provider  => 'rpm',
  #   ensure    => latest,
  #   source    => '/mnt/xcat/install/post/software/GPFS/fixes/gpfs.base-3.4.0-15.x86_64.update.rpm',
  #   require   => Package['gpfs.base'],
  # }

  if $update_source =~ /gpfs\.base-(.*)\..*\.update/ {
    $update_version  = $1
  }

  exec {'gpfs.update':
    command => "/bin/rpm -Uvh ${update_source}",
    unless  => "/bin/rpm -qa gpfs.base | grep ${update_version}",
    require => Package['gpfs.base'],
  }

  file{'/etc/profile.d/gpfs_env.sh':
    content => 'export PATH=$PATH:/usr/lpp/mmfs/bin/',
    require => Exec['gpfs.update']
  }

  package {'gpfs.gplbin':
    provider  => 'rpm',
    ensure    => installed,
    source    => $ports_source,
    require   => Exec['gpfs.update'],
  }

}
