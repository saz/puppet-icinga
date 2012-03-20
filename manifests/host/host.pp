define icinga::host::host(
  $icinga_alias = $::hostname,
  $icinga_ipaddress = $::ipaddress,
  $icinga_hostgroups = $::lsbdistid,
  $distro = $::lsbdistid
) {
  include icinga::params

  $distro_real = downcase($distro)

  @@nagios_host { $name:
    ensure     => present,
    alias      => $icinga_alias,
    address    => $icinga_ipaddress,
    use        => 'generic-host',
    hostgroups => $icinga_hostgroups,
    target     => "${icinga::params::objects_dir}hosts/${name}.cfg",
  }
}
