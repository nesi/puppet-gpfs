define gpfs::cluster(
  $server
){

  require gpfs

  # For this to work, the GPFS server's host key must already be known
  # try using the sshkey resource
  exec{"gpfs_cluster_${name}_${server}":
    command => "/usr/lpp/mmfs/bin/mmsdrrestore -p ${server} -R /usr/bin/scp",
    creates => "/var/mmfs/gen/mmsdrfs"
  }
}