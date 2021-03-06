# == Class: burp
#
# Install and manage Burp: a network backup and restore program.
#
# === Parameters
#
# [*version*]
#   Burp version to install.
#
# [*client*]
#   Is your instance a burp client or not?
#
# [*server*]
#   Is your instance a burp server or not?
#
# [*clientconf_hash*]
#   Every client needs a client config file on the server.
#
# [*common*]
#   Settings that apply to all clients.
#
# [*burp_server_hash*]
#   Burp server settings.
#
# [*burp_hash*]
#   Burp client settings.
#
# === Examples
#
#  class { burp:
#    version => "1.4.38",
#    client  => true,
#    server  => true
#  }
#
# === Authors
#
# Author Name rudi.broekhuizen@naturalis.nl
#
# === Copyright
#
# Copyright 2015 Rudi Broekhuizen.
#
class burp (

  # general
  $version = '1.4.38',
  $server  = true,
  $client  = true,

  # server: create client config files in /etc/burp/clientconfdir
  $clientconf_hash = { 'localhost'          => { clientconf => [ 'password = password',
                                                                 '. incexc/common'
                                                               ],
                                               },
                       'workstation.domain' => { clientconf => [ 'password = password',
                                                                 '. incexc/common'
                                                               ],
                                               },
                     },

  # server: settings that apply to all clients /etc/burp/clientconfdir/incexc/common
  $common = [ 'randomise = 1200' ],

  # server: settings for /etc/burp-server.conf
  $burp_server_hash = { '' => { 'ssl_key_password' => 'password',
                                'directory'        => '/backup',
                              },
                      },

  # client: settings for /etc/burp/burp.conf
  $burp_hash = { '' => { 'server'             => '127.0.0.1',
                         'ssl_key_password'   => 'password',
                         'password'           => 'password',
                         'server_can_restore' => '1',
                         'setting'            => { 'ensure' => 'absent'
                                                 },
               },

                 '/home' => { 'include' => '/home',
                            },
               },
) {

  class { 'burp::package':
  }

  if $server == true {
    class { 'burp::server':
      require => Class['burp::package']
    }
    class { 'burp::service':
      require => Class['burp::server']
    }
  }

  if $client == true {
    class { 'burp::client':
      require => Class['burp::package']
    }
  }

}
