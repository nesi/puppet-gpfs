# GPFS

This is a GPFS puppet module to install and configure the General Parallel File System (GPFS) from IBM.

# Prerequisites

Licenses to use GPFS will be required from IBM, as well as the install package (`gpfs.base`) and updates (`gpfs.base*update.rpm`) from which a kernel specific package (`gpfs.gplbin`) will need to be compiled for the kernel release being used on your systems.

This module can then be used to distribute and install these packages over many Puppet managed servers.

# Building the binary RPM

This are generic steps to build the binary package for GPFS 3.5.0-18 on RHEL 6.5. YMMV

* Install rpm-build, gcc-c++ (you might need more packages depending on what you install by default)
* Install GPFS's base RPMs
* Install GPFS's update RPMs
* Configure GPFS
```Shell
# You might have to pass LINUX_DISTRIBUTION= if your OS version is not recognised (GPFS v3.5.0 needed it for RHEL6)
make Autoconfig LINUX_DISTRIBUTION=REDHAT_RHEL6
```
* Build GPFS
```Shell
  make World
  make rpm
```

# Usage

Basic usage:

```Puppet
class { '::gpfs':
  source_url => '/path/to/gpfs/rpms',
  version    => '3.5.0',
  update     => '18',
}
```

Will install:
 * `/path/to/gpfs/rpms/gpfs.base-3.5.0-0.${::architecture}.rpm`
 * `/path/to/gpfs/rpms/gpfs.base-3.5.0-18.${::architecture}.update.rpm`
 * `/path/to/gpfs/rpms/gpfs.gplbin-${::kernelrelease}-3.5.0-0.${::architecture}.rpm`

using facts for the kernel release and architecture.

# References

* [GPFS Official Homepage](http://www-03.ibm.com/systems/software/gpfs/)

# Licensing

GPFS is only available under licence from IBM. This module does not grant a license to use GPFS.

# Attribution

This module is derived from the puppet-blank module by Aaron Hicks (aethylred@gmail.com)

* https://github.com/Aethylred/puppet-blank

This module has been developed for the use with Open Source Puppet (Apache 2.0 license) for automating server & service deployment.

* http://puppetlabs.com/puppet/puppet-open-source/

# Gnu General Public License

This file is part of the blank Puppet module.

The blank Puppet module is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

The blank Puppet module is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with the blank Puppet module.  If not, see <http://www.gnu.org/licenses/>.