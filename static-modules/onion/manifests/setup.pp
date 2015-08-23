# Setting up security onion using sosetup
class onion::setup(
  $mgmt_ifc = 'eth0',
  $sniff_ifc = 'eth1',
  $user,
  $password,
  $email
) {

  file { '/tmp/sosetup.conf':
    ensure  => file,
    mode    => '0644',
    content => template('onion/sosetup.conf.erb'),
    owner   => root,
    group   => root,
  } ->

  exec{'so global setup run':
    command     => 'echo yes | sosetup -f /tmp/sosetup.conf >> /var/log/sosetup.log && touch /var/sosetup-skip.run',
    user        => 'root',
    environment => 'HOME=/home/vagrant',
    path        => ['/usr/bin','/bin',],
    onlyif      => 'grep promisc /etc/network/interfaces',
    unless      => 'test -f /var/sosetup-skip.run'
  } ->

  exec{'so network setup run':
    command     => 'yes | sosetup-network -f /tmp/sosetup.conf >> /var/log/sosetup-network.log',
    user        => 'root',
    environment => 'HOME=/home/vagrant',
    path        => ['/usr/bin','/bin',],
    unless      => 'grep promisc /etc/network/interfaces'
  }
}
