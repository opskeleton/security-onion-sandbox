group{ 'puppet': ensure  => present }

node 'security-onion.local' {
  include onion

  class{'onion::mount':
    device => '/dev/sdb',
    dest   => '/data'
  }
}
