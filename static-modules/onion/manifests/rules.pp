# nsm rules management
class onion::rules(
  $disabled=['dropbox_usage']
) {
  $ids = {
    'dropbox_usage'     => '2012647',
    'dropbox_broadcast' => '2012648',
    'apt_outbound'      => '2013504'
  }

  file { '/etc/nsm/pulledpork/disablesid.conf':
    ensure  => file,
    mode    => '0644',
    content => template('onion/disablesid.conf.erb'),
    owner   => root,
    group   => root,
  } ~>

  exec{'update snort rules':
    command     => '/usr/bin/rule-update',
    refreshonly => true,
    user        => 'root',
    path        => ['/usr/bin','/bin'],
  }
}
