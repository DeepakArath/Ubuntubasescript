class s3cmd::install  {
 
exec { "s31" :
        command => "wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | sudo apt-key add -",
     }
	 
exec { "s32" :
      command => "wget -O/etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list",
      require => Exec ['s31'], }                  

exec { "s33" :
       command => "apt-get -y update",
       require => Exec["s32"],
     }

exec { "s34" :
       command => "apt-get install -y s3cmd",
       require => Exec["s33"],
     }
				        
file    {  "s3cfg":
             path  => "/root/.s3cfg",
             source => "puppet:///modules/s3cmd/s3cfg",
             mode => 644,
             owner   => "root",
             group   => "root",
             ensure    => present,
             require => Exec["s34"],
                    }

$ackey = 'access_key'
$scrtkey = 'secret_key'
$encrypass = 'gpg_passphrase'
$gpgpath = 'gpg_command' 
$usehttps = 'use_https' 
$httpproxy = 'proxy_host'
$httpport = 'proxy_port'
$flname = '/root/.s3cfg'

exec {"acceskey":
             command => "sed -i '/${ackey}/c\access_key  =  ${aceskey}' '${flname}'",
             require   =>  File["s3cfg"],             
     }
exec {"secretkey":
             command => "sed -i '/${scrtkey}/c\'${scrtkey}'  =  ${secrtkey}' '${flname}'",
             require   =>  File["s3cfg"],
     }
exec {"encrptnpasswd":
             command => "sed -i '/${encrypass}/c\gpg_passphrase  =  ${encryptpass}' '${flname}'",
             require   =>  File["s3cfg"],
     }
exec {"path2gpg":
             command => "sed -i '/${gpgpath}/c\gpg_command  =  ${pathgpg}' '${flname}'",
             require   =>  File["s3cfg"],
     }
exec {"usehttps":
             command => "sed -i '/${usehttps}/c\use_https  =  ${httpuse}' '${flname}'",
             require   =>  File["s3cfg"],
     }
exec {"httpproxy":
             command => "sed -i '/${httpproxy}/c\proxy_host  =  ${proxyhttp}' '${flname}'",
             require   =>  File["s3cfg"],
     }
exec {"httpport":
             command => "sed -i '/${httpport}/c\proxy_port  =  ${proxyprt}' '${flname}'",
             require   =>  File["s3cfg"],
     }
}
class s3cmd ($aceskey, $secrtkey, $encryptpass, $pathgpg, $httpuse, $proxyhttp, $proxyprt)
{
         include s3cmd::install
	    }
