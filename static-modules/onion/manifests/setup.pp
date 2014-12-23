# Setting up security onion using sosetup
class onion::setup(
  $mgmt_ifc = 'eth0',
  $sniff_ifc = 'eth2',
  $user,
  $password,
  $email
) {

  file { '/tmp/sosetup.conf':
    ensure=> file,
    mode  => '0644',
    content => template('onion/sosetup.conf.erb'),
    owner => root,
    group => root,
  } ->

  exec{'first so setup run':
    command => 'echo yes | sosetup -f /tmp/sosetup.conf >> /var/log/sosetup.log',
    user    => 'root',
    path    => ['/usr/bin','/bin',]
  }

}
