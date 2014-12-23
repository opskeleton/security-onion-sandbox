# nsm rules management
class onion::rules(
  $disabled=['dropbox_usage']
) {
  $ids = {'dropbox_usage' => '2012647'}

  file { '/etc/nsm/pulledpork/disablesid.conf':
    ensure  => file,
    mode    => '0644',
    content => template('onion/disablesid.conf.erb'),
    owner   => root,
    group   => root,
  }
}
