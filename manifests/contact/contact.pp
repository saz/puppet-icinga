define icinga::contact::contact(
  $email,
  $address1 = undef,
  $pager = undef,
  $contactgroups = undef,
  $use = undef,
  $service_notification_period = '24x7',
  $service_notification_options = 'w,u,c,r',
  $service_notification_commands = 'service-notify-by-email',
  $service_notifications_enabled = 1,
  $host_notification_period = '24x7',
  $host_notification_options = 'd,r',
  $host_notification_commands = 'host-notify-by-email',
  $host_notifications_enabled = 1,
  $can_submit_commands = 1,
  $register = 1
) {
  include icinga::params

  @@nagios_contact { $name:
    ensure                        => present,
    register                      => $register,
    address1                      => $address1,
    alias                         => $name,
    can_submit_commands           => $can_submit_commands,
    contactgroups                 => $contactgroups,
    email                         => $email,
    host_notification_period      => $host_notification_period,
    host_notification_options     => $host_notification_options,
    host_notification_commands    => $host_notification_commands,
    host_notifications_enabled    => $host_notifications_enabled,
    service_notification_period   => $service_notification_period,
    service_notification_options  => $service_notification_options,
    service_notification_commands => $service_notification_commands,
    service_notifications_enabled => $service_notifications_enabled,
    use                           => $use,
    target                        => "${icinga::params::objects_dir}contacts/${name}.cfg",
  }
}
