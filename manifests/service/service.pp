define icinga::service::service(
  $command,
  $servicegroups = undef,
  $host = $::fqdn,
  $alias = $::hostname,
  $append_name = false
) {
  include icinga::params

  if $append_name == true {
    $command_real = "${command}${name}"
  } else {
    $command_real = $command
  }

  @@nagios_service { "${host}_${name}":
    ensure              => present,
    check_command       => $command_real,
    host_name           => $alias,
    servicegroups       => $servicegroups,
    service_description => $name,
    use                 => 'generic-service',
    target              => "${icinga::params::objects_dir}services/${host}_${name}.cfg",
  }
}
