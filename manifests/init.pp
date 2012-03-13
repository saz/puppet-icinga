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
  $package = $icinga::params::package,
  $config_dir = $icinga::params::config_dir,
  $config_dir_purge = $icinga::params::config_dir_purge,
  $config_dir_recurse = $icinga::params::config_dir_recurse,
  $service_ensure = $icinga::params::service_ensure,
  $service = $icinga::params::service,
  $service_enable = $icinga::params::service_enable,
  $service_hasstatus = $icinga::params::service_hasstatus,
  $service_hasrestart = $icinga::params::service_hasrestart,
  $service_pattern = $icinga::params::service_pattern
) inherits icinga::params {

  validate_bool(
    $autoupgrade,
    $config_dir_purge,
    $config_dir_recurse,
    $service_enable,
    $service_hasstatus,
    $service_hasrestart
  )

  validate_string(
    $package,
    $config_dir,
    $service
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

  package { $package:
    ensure => $package_ensure,
  }

  file { $config_dir:
    ensure  => $dir_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    purge   => $config_dir_purge,
    recurse => $config_dir_recurse,
    force   => true,
    require => Package[$package],
    notify  => Service[$service],
  }

  file { "${config_dir}cgi.cfg":
    ensure => file,
  }

  file { "${config_dir}icinga.cfg":
    ensure => file,
  }

  file { "${config_dir}apache2.conf":
    ensure => file,
  }

  file { "${config_dir}commands.cfg":
    ensure => file,
  }

  file { "${config_dir}resource.cfg":
    ensure => file,
  }

  file { "${config_dir}modules":
    ensure => directory,
  }

  file { "${config_dir}stylesheets":
    ensure  => directory,
    recurse => false,
    purge   => false,
  }

  file { "${config_dir}objects":
    ensure => directory,
  }

  file { "${config_dir}objects/services/":
    ensure => directory,
  }
  
  file { "${config_dir}objects/hosts/":
    ensure => directory,
  }

  file { "${config_dir}objects/commands/":
    ensure => directory,
  }

  file { "${config_dir}objects/hostgroups/":
    ensure => directory,
  }

  file { "${config_dir}objects/hostextinfo/":
    ensure => directory,
  }

  service { $service:
    ensure     => $service_ensure_real,
    enable     => $service_enable,
    hasstatus  => $service_hasstatus,
    hasrestart => $service_hasrestart,
    pattern    => $service_pattern,
    require    => Package[$package],
  }

}
