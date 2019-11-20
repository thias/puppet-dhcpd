# Class: dhcpd
#
# Installs and enables a dhcpd server. You must specify either `$configsource`
# or `$configcontent`.
#
# Parameters:
#  $configsource:
#    Puppet location of the configuration file to use. Default: none
#  $configcontent:
#    Content of the configuration file to use. Default: none
#  $dhcpdargs:
#    Command-line arguments to be added to dhcpd. Default: empty
#  $ensure:
#    Ensure parameter for the service. Default: undefined
#  $enable:
#    Enable parameter for the service. Default: true
#
# Sample Usage :
#  class { 'dhcpd':
#    configsource => 'puppet:///files/dhcpd.conf-foo',
#    # Restrict listening to a single interface
#    dhcpdargs    => 'eth1',
#    # Default is to enable but allow to be stopped (for active/passive)
#    ensure       => 'running',
#  }
#
class dhcpd (
  $configsource  = undef,
  $configcontent = undef,
  $dhcpdargs     = '',
  $ensure        = undef,
  $enable        = true,
) {

  package { 'dhcp': ensure => installed }

  service { 'dhcpd':
    ensure    => $ensure,
    enable    => $enable,
    hasstatus => true,
    require   => Package['dhcp'],
  }

  file { '/etc/sysconfig/dhcpd':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dhcpd/dhcpd.sysconfig.erb'),
    notify  => Service['dhcpd'],
  }

  # RHEL 5 has a different location
  if versioncmp($::operatingsystemrelease, '6') < 0 {
    $dhcpd_conf = '/etc/dhcpd.conf'
  } else {
    $dhcpd_conf = '/etc/dhcp/dhcpd.conf'
  }
  file { $dhcpd_conf :
    owner        => 'root',
    group        => 'root',
    mode         => '0644',
    source       => $configsource,
    content      => $configcontent,
    require      => Package['dhcp'],
    validate_cmd => '/usr/sbin/dhcpd -t -cf %',
    notify       => Service['dhcpd'],
  }

}

