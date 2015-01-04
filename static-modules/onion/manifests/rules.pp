# nsm rules management
class onion::rules(
  $disabled=['dropbox_usage'],
  $oinkcode= '',
) {
  $ids = {
    'dropbox_usage'     => '2012647',
    'dropbox_broadcast' => '2012648',
    'apt_outbound'      => '2013504',
    'torrent_peer'      => '2000334'
  }

  $parent = 'https://www.snort.org/reg-rules/'

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

  if($oinkcode !=''){
    file_line { 'snapshots url':
      path => '/etc/nsm/pulledpork/pulledpork.conf',
      line => "${parent}|snortrules-snapshot.tar.gz|${oinkcode}"
    } ~> Exec['update snort rules']

    file_line { 'opensource url':
      path => '/etc/nsm/pulledpork/pulledpork.conf',
      line => "${parent}|opensource.tar.gz|${oinkcode}",
    } ~> Exec['update snort rules']
  }
}
