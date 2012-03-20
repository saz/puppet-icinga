class icinga::common {
  include icinga::params

  $distro = downcase($::lsbdistid)

  icinga::host::host { $::fqdn: }
  icinga::host::hostextinfo { $::fqdn: }

  @@nagios_service { "check_ping_${::fqdn}":
    check_command       => 'check_ping!5000,50%!5000,100%',
    service_description => 'ping',
    use                 => 'generic-service',
    host_name           => $::fqdn,
    target              => "${icinga::params::objects_dir}services/${::fqdn}_check_ping.cfg",
  }
}
