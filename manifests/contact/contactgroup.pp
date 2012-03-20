define icinga::contact::contactgroup(
  $contactgroup_members = undef,
  $members = undef,
  $use = undef,
  $register = 1,
) {
  include icinga::params

  @@nagios_contactgroup { $name:
    ensure               => present,
    alias                => $name,
    members              => $members,
    contactgroup_members => $contactgroup_members,
    register             => $register,
    use                  => $use,
    target               => "${icinga::params::objects_dir}contactgroups/${name}.cfg",
  }
}
