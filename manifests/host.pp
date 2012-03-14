class icinga::host {
  include icinga::params

  $distro = downcase($::lsbdistid)

  @@nagios_host { $::fqdn:
    ensure  => present,
    alias   => $::hostname,
    address => $::ipaddress,
    use     => 'generic-host',
    target  => "${icinga::params::objects_dir}hosts/${::fqdn}.cfg",
  }

  @@nagios_hostextinfo { $::fqdn:
    ensure          => present,
    icon_image_alt  => $::lsbdistid,
    icon_image      => "base/${distro}.png",
    statusmap_image => "base/{$distro}.gd2",
    target          => "${icinga::params::objects_dir}hostextinfo/${::fqdn}.cfg",
  }

  @@nagios_service { "check_ping_${::fqdn}":
    check_command       => 'check_ping!5000,50%!5000,100%',
    service_description => 'ping',
    use                 => 'generic-service',
    host_name           => $::fqdn,
    target              => "${icinga::params::objects_dir}services/${::fqdn}_check_ping.cfg",
  }
}
