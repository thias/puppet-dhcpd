class { 'dhcpd':
  # Bogus, we just need a file
  configsource => "puppet:///modules/${module_name}/dhcpd.conf-example",
  dhcpdargs    => 'br1',
  ensure       => 'running',
}
