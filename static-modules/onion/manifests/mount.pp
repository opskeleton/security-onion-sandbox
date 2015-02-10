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
      path    => ['/usr/bin','/bin',]
    } ->

    file{$dest:
      ensure => directory,
    } ->

    mkfs::device {$device:
      dest   => $dest
    } ->

    exec{'move /nsm aside':
      command => "mv /nsm ${dest}",
      user    => 'root',
      path    => '/bin/'
    } ->

    file{'/nsm':
      ensure => link,
      target => "${dest}/nsm"
    }
  }
}
