# Replacing /nsm mount point see
# https://code.google.com/p/security-onion/wiki/NewDisk
class onion::mount(
  $device='',
  $dest =''
){
  if($device != '' and $dest !=''){
    exec{'service nsm stop':
      command => 'service nsm stop',
      user    => 'root',
      path    => ['/usr/bin','/bin',]
    } ->

    exec{'move /nfs aside':
      command => 'mv /nsm /nsm_bac',
      user    => 'root',
      path    => '/bin/'
    }

    class{'mkfs':
      device => $device,
      dest => $dest
    }
  }

}
