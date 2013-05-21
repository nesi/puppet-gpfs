# GPFS

This is a GPFS puppet module to install and configure the General Parallel File System (GPFS) from IBM.

# Prerequisites

Licenses to use GPFS will be required from IBM, as well as the install package (`gpfs.base`) and updates (`gpfs.base*update.rpm`) from which a kernal ports package (`gpfs.ports`) will need to be compiled for the specific kernel being used on your systems.

This module can then be used to distribute and install these packages over many Puppet managed servers.

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