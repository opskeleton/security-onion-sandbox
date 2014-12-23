group{ 'puppet': ensure  => present }

node 'security-onion.local' {
  include onion
}
