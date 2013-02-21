class nfs-server::install {

package {"nfs-kernel-server":
        name => "nfs-kernel-server",
		ensure => present,
before => Package['portmap'],		       
        }
package {"portmap":
        name => "portmap",
                ensure => present,
require => Package['nfs-kernel-server'],
        }
package {"nfs-common":
        name => "nfs-common",
                ensure => present,
require => Package['portmap'],
        }
			  }

class nfs-server::config {

$filename = '/etc/exports' 
$dir = '/prime.fs'
$perm = '(rw,no_subtree_check,sync,no_root_squash)'

include nfs-server::install
exec { "10" :
       command => "mkdir -p /prime.fs",
       require => Class["nfs-server::install"],
     }

file { "/etc/exports": ensure => present, }
exec { "11" :
       command => "echo '${dir}'      '${ipaddr}''${perm}' >> '${filename}'",
       require => File ["/etc/exports"],
       notify   =>  Service["nfs-kernel-server"],
     }

service { "nfs-kernel-server":
            ensure    => "running",
            enable    => "true",
            require   => Package["nfs-kernel-server"],
        hasrestart => true,
        hasstatus => true,
        subscribe => File["/etc/exports"],

        }
exec { "16" :
       command => "ufw allow proto tcp from 10.177.7.163 to any port 111",
       before => Exec["17"],
     }
exec { "17" :
       command => "ufw allow proto tcp from 10.177.7.163 to any port 2049",
       require => Exec["16"],
     }


			 }
class nfs ($ipaddr) {

include nfs-server::config
	            }

