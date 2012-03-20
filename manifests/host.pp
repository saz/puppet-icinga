class icinga::host(
  $icinga_hostname = $::fqdn,
  $icinga_alias = $::hostname,
  $icinga_ipaddress = $::ipaddress,
  $distro = $::lsbdistid
) inherits icinga::params {

  $distro_real = downcase($distro)

  @@nagios_host { $icinga_hostname:
    ensure  => present,
    alias   => $icinga_alias,
    address => $icinga_ipaddress,
    use     => 'generic-host',
    target  => "${icinga::params::objects_dir}hosts/${icinga_hostname}.cfg",
  }

  @@nagios_hostextinfo { $icinga_hostname:
    ensure          => present,
    icon_image_alt  => $distro,
    icon_image      => "base/${distro_real}.png",
    statusmap_image => "base/{$distro_real}.gd2",
    target          => "${icinga::params::objects_dir}hostextinfo/${icinga_hostname}.cfg",
  }

  @@nagios_service { "check_ping_${icinga_hostname}":
    check_command       => 'check_ping!5000,50%!5000,100%',
    service_description => 'ping',
    use                 => 'generic-service',
    host_name           => $icinga_hostname,
    target              => "${icinga::params::objects_dir}services/${icinga_hostname}_check_ping.cfg",
  }
}
