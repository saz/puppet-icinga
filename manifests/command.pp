class icinga::command {
  icinga::command::command { 'host-notify-by-email':
    command_line => '/usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: $NOTIFICATIONTYPE$\nHost: $HOSTALIAS$\nState: $HOSTSTATE$ for $HOSTDURATION$\nAddress: $HOSTADDRESS$\nInfo:\n\n$HOSTOUTPUT$\n\nDate/Time: $LONGDATETIME$\n\nACK by: $HOSTACKAUTHOR$\nComment: $HOSTACKCOMMENT$\n" | /usr/bin/mail -s "** $NOTIFICATIONTYPE$ alert $NOTIFICATIONNUMBER$ - $HOSTALIAS$ host is $HOSTSTATE$ **" $CONTACTEMAIL$',
  }

  icinga::command::command { 'service-notify-by-email':
    command_line => '/usr/bin/printf "%b" "***** Nagios  *****\n\nNotification Type: $NOTIFICATIONTYPE$\n\nService: $SERVICEDESC$\nHost: $HOSTALIAS$\nState: $SERVICESTATE$ for $SERVICEDURATION$\nAddress: $HOSTADDRESS$\n\nInfo:\n\n$SERVICEOUTPUT$\n\nDate/Time: $LONGDATETIME$\n\nACK by: $SERVICEACKAUTHOR$\nComment: $SERVICEACKCOMMENT$\n" | /usr/bin/mail -s "** $NOTIFICATIONTYPE$ alert $NOTIFICATIONNUMBER$ - $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$ **" $CONTACTEMAIL$',
  }
}
