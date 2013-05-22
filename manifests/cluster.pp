define gpfs::cluster(
  $server
){

  require gpfs

  exec{"gpfs_cluster_${name}_${server}":
    command => "/usr/lpp/mmfs/bin/mmsdrrestore  -p ${server} -R /usr/bin/scp",
    creates => "/var/mmfs/gen/mmsdrfs"
  }
}