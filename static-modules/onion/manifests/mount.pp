# Replacing /nsm mount point see
# https://code.google.com/p/security-onion/wiki/NewDisk
class onion::mount($device='', $dest =''){
  if($device != '' and $dest !=''){

    if($dest == '/nsm'){
      fail('destination path cannot be /nsm')
    }

    exec{'service nsm stop':
      command => 'service nsm stop',
      user    => 'root',
      unless  => "test -L ${dest}/nsm && test -L ${dest}/var/log/nsm",
      path    => ['/usr/bin','/bin',]
    } ->

    file{$dest:
      ensure => directory,
    } ->

    mkfs::device {$device:
      dest   => $dest
    } ->

    file{["${dest}/var/", "${dest}/var/log/"]:
      ensure => directory,
    }

    exec{'move /nsm aside':
      command => "mv /nsm ${dest}",
      user    => 'root',
      path    => '/bin/',
      creates => "${dest}/nsm",
      require => Mkfs::Device[$device]
    } ->

    file{'/nsm':
      ensure => link,
      target => "${dest}/nsm"
    }

    exec{'move /var/log/nsm aside':
      command => "mv /var/log/nsm ${dest}/var/log/",
      user    => 'root',
      path    => '/bin/',
      creates => "${dest}/var/log/nsm",
      require => [Mkfs::Device[$device], File["${dest}/var/log"]]
    } ->

    file{'/var/log/nsm':
      ensure => link,
      target => "${dest}/var/log/nsm"
    }

  }
}
