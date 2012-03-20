define icinga::host::hostgroup {
  include icinga::params

  $alias = capitalize($name)

  nagios_hostgroup { $name:
    ensure => present,
    alias  => $alias,
    target => "${icinga::params::objects_dir}hostgroups/${name}.cfg",
  }
}
