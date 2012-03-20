define icinga::host::hostextinfo(
  $distro = $::lsbdistid
) {
  include icinga::params

  $distro_lc = downcase($::lsbdistid)

  @@nagios_hostextinfo { $name:
    ensure          => present,
    icon_image_alt  => $distro,
    icon_image      => "base/${distro_lc}.png",
    statusmap_image => "base/${distro_lc}.gd2",
    target          => "${icinga::params::objects_dir}hostextinfo/${name}.cfg",
  }
}
