# puppet-dhcpd

## Overview

This module installs and enables a dhcpd server using a pre-existing
configuration file or template generated outside of the module's scope.
This is because all possible dhcpd configuration files would be hard
to base on a single template without introducing lots of complexity,
either in the amount of parameters or the structure (hashes) to pass them.

Included are a static `dhcpd.conf-example` file to get started, as well as
a simple `dhcpd.conf-simple.erb` template for very simple dhcpd servers.

Parameters to the main `::dhcpd` class :

* `$configsource` : Puppet location of the conf file to use. Default: none
* `$configcontent` : Content of the config file to use. Default: none
* `$dhcpdargs` : Command-line arguments to be added to dhcpd. Default: empty
* `$ensure` : Ensure parameter for the service. Default: undef
* `$enable` : Enable parameter for the service. Default: true

## Examples

Pre-existing custom static `dhcpd.conf` file :
```puppet
class { '::dhcpd':
  configsource => 'puppet:///modules/mymodule/dhcpd.conf-foo',
  # Restrict listening to a single interface
  dhcpdargs    => 'eth1',
  # Default is to enable but allow to be stopped (for active/passive)
  ensure       => 'running',
}
```

Trivial configuration using the included example template :
```puppet
class { '::dhcpd':
  configcontent => template('dhcpd/dhcpd.conf-simple.erb'),
}
```

Slightly more complex configuration using the included example template :
```puppet
# Variables used from inside the template
$dhcpd_netmask             = '255.255.255.0'
$dhcpd_subnet              = '192.168.100.0'
$dhcpd_routers             = '192.168.100.1'
$dhcpd_domain_name_servers = '192.168.100.1,192.168.100.2'
$dhcpd_range_start         = '100'
$dhcpd_range_end           = '254'
$dhcpd_default_lease_time  = '3600'
$dhcpd_max_lease_time      = '21600'
class { '::dhcpd':
  configcontent => template('dhcpd/dhcpd.conf-simple.erb'),
  ensure        => 'running',
}
```

