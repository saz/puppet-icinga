class icinga::params {
  case $::operatingsystem {
    ubuntu, debian: {
      $package = 'icinga'
      $config_dir = '/etc/icinga/'
      $config_dir_purge = true
      $config_dir_recurse = false
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
}
