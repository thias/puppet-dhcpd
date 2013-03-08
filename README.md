# puppet-dhcpd

## Overview

This module installs and enables a dhcpd server using a pre-existing
configuration file. This is because different dhcpd configuration files would
be hard to base on a single template without introducing unnecessary
complexity. Included is a dhcpd.conf-example file to get started.

* `dhcpd` : Install and enable a DHCP server.

## Examples

    class { 'dhcpd':
      configsource => 'puppet:///modules/mymodule/dhcpd.conf-foo',
      # Restrict listening to a single interface
      dhcpdargs    => 'eth1',
      # Default is to enable but allow to be stopped (for active/passive)
      ensure       => 'running',
    }

