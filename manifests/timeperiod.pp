define icinga::timeperiod {
  include icinga::params

  $alias = capitalize($name)

  @@nagios_timeperiod { $name:
    ensure    => present,
    alias     => $alias,
    sunday    => '00:00-24:00',
    monday    => '00:00-24:00',
    tuesday   => '00:00-24:00',
    wednesday => '00:00-24:00',
    thursday  => '00:00-24:00',
    friday    => '00:00-24:00',
    saturday  => '00:00-24:00',
    target    => "${icinga::params::objects_dir}timeperiods/${name}.cfg",
  }
}
