# nsm rules management
class onion::rules(
  $disabled=['dropbox_usage'],
  $oinkcode= '',
) {
  $ids = {
    'dropbox_usage'      => '2012647',
    'dropbox_broadcast'  => '2012648',
    'apt_outbound'       => '2013504',
    'torrent_peer'       => '2000334',
    'tor_ssl'            => '2018789',
    'sur_stream_est'     => '2210021',
    'http_non_rfc_char'  => '14',
    'stream5_reset'      => '15',
    'http_no_length'     => '3',
    'http_unkown_method' => '31'
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
