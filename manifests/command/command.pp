define icinga::command::command(
  $command_line
) {
  include icinga::params

  @@nagios_command { $name:
    ensure       => present,
    command_line => $command_line,
    target       => "${icinga::params::objects_dir}commands/${name}.cfg",
  }
}
