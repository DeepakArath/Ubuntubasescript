class preq::install  {
 
exec { "preq1" :
        command => "gpg --keyserver  hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A",
     before => File ["/etc/apt/sources.list"], 
     }
	 
exec { "preq2" :
      command => "gpg -a --export CD2EFD2A | apt-key add -",
      require => Exec ['preq1'], }                  

file { "/etc/apt/sources.list": ensure => present, }

$filename = '/etc/apt/sources.list'

exec { "cmd1" :
       command => "echo deb http://repo.percona.com/apt precise main >> '${filename}'",
      require => Exec ['preq2'],
     }

exec { "cmd2" :
       command => "echo deb-src http://repo.percona.com/apt precise main >> '${filename}'",
       require => Exec ['cmd1'],
     }
					  }
 
class percona::install {

#$pass = ' '
include preq::install

exec {"1":
command => "/usr/bin/apt-get -y update",
#require => Class["preq::install"],
require => Exec["cmd2"], 
     }
	 
exec {"2":
        command => "echo percona-server-server-5.5   percona-server-server/root_password password $password | sudo debconf-set-selections",
        require => Exec ["1"], 
	 }

exec {"3":
        command => "echo percona-server-server-5.5   percona-server-server/root_password_again password $password | sudo debconf-set-selections",
        require => Exec ["2"],
     }

exec {"4":
        command => "/usr/bin/apt-get install -y percona-server-server-5.5 percona-server-client-5.5",
        require => Exec ["3"],
	 }
					   }

class mysql ($password){
             include percona::install
	        }

