class icinga::params {
  case $::operatingsystem {
    ubuntu, debian: {
      $package = 'icinga'
      $config_dir = '/etc/icinga/'
      $config_file = "${config_dir}icinga.cfg"
      $service_ensure = 'running'
      $service = 'icinga'
      $service_enable = true
      $service_hasstatus = true
      $service_hasrestart = true
      $service_pattern = "/usr/sbin/icinga -d ${config_file}"
    }
    default: {
      fail("Unsupported platform: ${::operatingsystem}")
    }
  }

  $objects_dir = "${config_dir}objects"
}
