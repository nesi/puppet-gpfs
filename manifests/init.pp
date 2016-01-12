# Class: gpfs
#
# This module manages gpfs
#
# Parameters:
#
#  [*source_module_install*]
#    If set to false, installs the kernel modules from an RPM (gpfs.gplbin-${::kernelrelease}-3.5.0-0.${::architecture}.rpm).
#    If set to true, installs the kernel moduels from source.
#    Default: false
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
  $source_module_install = false,
) {

  $base_source   = "${source_url}/gpfs.base-${version}-0.${::architecture}.rpm"
  $update_source = "${source_url}/gpfs.base-${version}-${update}.${::architecture}.update.rpm"
  $gpl_update_source = "${source_url}/gpfs.gpl-${version}-${update}.noarch.rpm"
  $msg_source = "${source_url}/gpfs.msg.en_US-${version}-${update}.noarch.rpm"
  $ext_source = "${source_url}/gpfs.ext-${version}-0.${::architecture}.rpm"
  $ext_update_source = "${source_url}/gpfs.ext-${version}-${update}.${::architecture}.update.rpm"
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

  if ($version =~ /^4/) {
    if $manage_deps {
      $gpfs_4_deps = ['m4']

      package {$gpfs_4_deps:
        ensure  => installed,
        before  => Package['gpfs.base'],
      }
    }

    #Mapping between GPFS version and GSKit versions:
    case $version {
      '4.1.0': {
        $gskit_version = '8.0.50'
      }
    }
    case $update {
      '0': {
        $gskit_update = '16'
      }
      '7': {
        $gskit_update = '32'
      }
    }

    $gskit_source = "${source_url}/gpfs.gskit-${gskit_version}-${gskit_update}.${::architecture}.rpm"
    package {"gpfs.gskit":
      provider  => 'rpm',
      ensure    => installed,
      source    => $gskit_source,
    }

    package {"gpfs.msg.en_US":
      provider  => 'rpm',
      ensure    => installed,
      source    => $msg_source,
    }

    package {"gpfs.ext":
      provider  => 'rpm',
      ensure    => installed,
      source    => $ext_source,
    }

    exec {'gpfs.ext.update':
      command => "/bin/rpm -Uvh ${ext_update_source}",
      unless  => "/bin/rpm -qa gpfs.ext | grep ${version}",
      require => Package['gpfs.ext'],
    }
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

  if ($source_module_install) {
    package {"gpfs.gpl":
      provider  => 'rpm',
      ensure    => installed,
      source    => $gpl_update_source,
    }

    #  exec {'gpfs.gpl.update':
    #  command => "/bin/rpm -Uvh ${gpl_update_source}",
    #  unless  => "/bin/rpm -qa gpfs.gpl | grep ${update_version}",
    #  require => Package['gpfs.gpl'],
    #}
    if $manage_deps {
      $gpfs_source_deps = ['cpp','gcc','gcc-c++']

      package {$gpfs_source_deps:
        ensure  => installed,
        before  => Package['gpfs.base'],
      }

      package {"kernel-devel-${kernel_version}":
        ensure => installed,
        before  => Package['gpfs.gpl'],
      }
    }

    exec {'gpfs.gplbin':
      command     => "/usr/bin/make Autoconfig && /usr/bin/make World && /usr/bin/make InstallImages",
      environment => ["LINUX_DISTRIBUTION=REDHAT_AS_LINUX"],
      cwd         => "/usr/lpp/mmfs/src",
      creates     => "/lib/modules/${kernel_version}/extra/mmfs26.ko",
      require     => Package['gpfs.gpl'],
    }
  } else {
    package {'gpfs.gplbin':
      provider  => 'rpm',
      ensure    => installed,
      source    => $ports_source,
      require   => Exec['gpfs.update'],
    }
  }

}
