# Class: icinga
#
# This module manages icinga
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class icinga(
  $ensure = 'present',
  $autoupgrade = false,
  $service_ensure = 'running',
  $service_enable = true,
) inherits icinga::params {

  validate_bool(
    $autoupgrade,
    $service_enable,
  )

  case $ensure {
    present: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }

      case $service_ensure {
        running, stopped: {
          $service_ensure_real = $service_ensure
        }
        default: {
          fail("service_ensure parameter must be running or stopped, not ${service_ensure}")
        }
      }

      $file_ensure = 'file'
      $dir_ensure = 'directory'
    }
    absent: {
      $package_ensure = 'absent'
      $service_ensure_real = 'stopped'
      $file_ensure = 'absent'
      $dir_ensure = 'absent'
    }
    default: {
      fail("ensure parameter must be present or absent, not ${ensure}")
    }
  }

  package { $icinga::params::package:
    ensure => $package_ensure,
  }

  file { $icinga::params::config_dir:
    ensure  => $dir_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    purge   => true,
    recurse => false,
    force   => true,
    require => Package[$icinga::params::package],
    notify  => Service[$icinga::params::service],
  }

  file { 'cgi.cfg':
    ensure  => file,
    path    => "${icinga::params::config_dir}cgi.cfg",
    content => template('icinga/cgi.cfg.erb'),
    require => File[$icinga::params::config_dir],
    notify  => Service[$icinga::params::service],
  }

  file { 'icinga.cfg':
    ensure  => file,
    path    => $icinga::params::config_file,
    content => template('icinga/icinga.cfg.erb'),
    require => File[$icinga::params::config_dir],
    notify  => Service[$icinga::params::service],
  }

  file { "${icinga::params::config_dir}apache2.conf":
    ensure => file,
  }

  file { "${icinga::params::config_dir}htpasswd.users":
    ensure => file,
  }

  file { "${icinga::params::config_dir}commands.cfg":
    ensure => file,
    require => File[$icinga::params::config_dir],
    notify  => Service[$icinga::params::service],
  }

  file { "${icinga::params::config_dir}resource.cfg":
    ensure => file,
    require => File[$icinga::params::config_dir],
    notify  => Service[$icinga::params::service],
  }

  file { "${icinga::params::config_dir}modules":
    ensure  => $dir_ensure,
    require => File[$icinga::params::config_dir],
    notify  => Service[$icinga::params::service],
  }

  file { "${icinga::params::config_dir}stylesheets":
    ensure  => $dir_ensure,
    recurse => false,
    purge   => false,
    require => File[$icinga::params::config_dir],
    notify  => Service[$icinga::params::service],
  }

  file { 'objects_dir':
    ensure  => $dir_ensure,
    path    => $icinga::params::objects_dir,
    purge   => true,
    recurse => true,
    require => File[$icinga::params::objects_dir],
    notify  => Service[$icinga::params::service],
  }

  file { 'services_dir':
    ensure  => $dir_ensure,
    path   => "${icinga::params::objects_dir}services/",
    require => File[$icinga::params::objects_dir],
    notify  => Service[$icinga::params::service],
  }
  
  file { 'hosts_dir':
    ensure  => $dir_ensure,
    path   => "${icinga::params::objects_dir}hosts/",
    require => File[$icinga::params::objects_dir],
    notify  => Service[$icinga::params::service],
  }

  file { 'commands_dir':
    ensure  => $dir_ensure,
    path   => "${icinga::params::objects_dir}commands/",
    require => File[$icinga::params::objects_dir],
    notify  => Service[$icinga::params::service],
  }

  file { 'hostgroups_dir':
    ensure  => $dir_ensure,
    path   => "${icinga::params::objects_dir}hostgroups/",
    require => File[$icinga::params::objects_dir],
    notify  => Service[$icinga::params::service],
  }

  file { 'hostextinfo_dir':
    ensure  => $dir_ensure,
    path   => "${icinga::params::objects_dir}hostextinfo/",
    require => File[$icinga::params::objects_dir],
    notify  => Service[$icinga::params::service],
  }

  service { $service:
    ensure     => $service_ensure_real,
    enable     => $service_enable,
    hasstatus  => $service_hasstatus,
    hasrestart => $service_hasrestart,
    pattern    => $service_pattern,
    require    => File['icinga.cfg'],
  }

  exec { 'fix_icinga_perms':
    command     => "/bin/chown -R root:nagios '${icinga::params::objects_dir}'; /usr/bin/find ${icinga::params::objects_dir} -type f -exec chmod 640 '{}' \;",
    refreshonly => true,
    notify      => Service[$service],
  }

  Nagios_service <<||>> {
    notify  => Exec['fix_icinga_perms'],
  }

  Nagios_host <<||>> {
    notify  => Exec['fix_icinga_perms'],
  }

  Nagios_hostextinfo <<||>> {
    notify  => Exec['fix_icinga_perms'],
  }
}
