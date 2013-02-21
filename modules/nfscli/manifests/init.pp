class nfs-client::install {

package {"nfs-common":
        name => "nfs-common",
                ensure => present,
        }
                          }
class nfs-client::config {

$filenme = '/etc/fstab'
$dir2 = '/mnt/prime.fs'
$perm1 = 'prime.fs.netspective.com:/prime.fs'
$perm2 = 'soft,intr,rsize=8192,wsize=8192'

include nfs-client::install
exec { "13" :
       command => "mkdir -p /mnt/prime.fs",
       require => Class["nfs-client::install"],
before => Exec["14"],     
}

file { "/etc/fstab": ensure => present, }

exec { "14" :
       command => "echo '${perm1}''\t' '${dir2}''\t'nfs'\t''${perm2}' >> '${filenme}'",
       require => File ["/etc/fstab"],
     }}
exec { "15" :
       command => "mount -a",
       require => Exec["13"],
     }

class nfscli  {
include nfs-client::config
              }

