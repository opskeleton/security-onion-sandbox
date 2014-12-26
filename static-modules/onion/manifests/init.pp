# managing security onion
class onion {
  include onion::rules

  package{'xscreensaver':
    ensure  => absent
  }
}
