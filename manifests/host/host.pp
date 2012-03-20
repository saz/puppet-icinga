define icinga::host::host(
  $icinga_alias = $::hostname,
  $icinga_ipaddress = $::ipaddress,
  $icinga_hostgroups = $::lsbdistid,
  $distro = $::lsbdistid
) {
  include icinga::params

  $distro_lc = downcase($distro)

  @@nagios_host { $name:
    ensure     => present,
    alias      => $icinga_alias,
    address    => $icinga_ipaddress,
    use        => 'generic-host',
    hostgroups => $distro_lc,
    target     => "${icinga::params::objects_dir}hosts/${name}.cfg",
  }
}
