class etckeeper::install {

$line1 = 'VCS="hg"' 
$line2 = 'VCS="git"'
$line3 = 'VCS="bzr"'
$line4 = 'VCS="darcs"'
$file = '/etc/etckeeper/etckeeper.conf'


        package {"etckeeper":
        name => "etckeeper",
		ensure => present,
		        }

	exec { "/usr/bin/etckeeper uninit -f":
		require => Package['etckeeper'],
		 }		 
		
    exec { "/bin/sed -i -e'/${line2}/s/#\+//' '${file}'" :
        onlyif => "/bin/grep '${line2}' '${file}' | /bin/grep '^#' | /usr/bin/wc -l",
         require => Package['etckeeper'],
         before => Exec['etckeeper init'],
	 }
    exec { "/bin/sed -i -e'/${line1}/s/\(.\+\)$/#\1/' '${file}'" :
        onlyif => "/usr/bin/test `/bin/grep '${line1}' '${file}' | /bin/grep -v '^#' | /usr/bin/wc -l` -ne 0",
         require => Package['etckeeper'],
	 before => Exec['etckeeper init'],
         }

    exec { "/bin/sed -i -e'/${line3}/s/\(.\+\)$/#\1/' '${file}'" :
        onlyif => "/usr/bin/test `/bin/grep '${line3}' '${file}' | /bin/grep -v '^#' | /usr/bin/wc -l` -ne 0",
         require => Package['etckeeper'],
	 before => Exec['etckeeper init'],
         }
    exec { "/bin/sed -i -e'/${line4}/s/\(.\+\)$/#\1/' '${file}'" :
        onlyif => "/usr/bin/test `/bin/grep '${line4}' '${file}' | /bin/grep -v '^#' | /usr/bin/wc -l` -ne 0",
         require => Package['etckeeper'],
 	 before => Exec['etckeeper init'],
         }
 
	exec { "etckeeper init": 
           require => Package['etckeeper'],
		 }

	exec { "etckeeper commit -am 'Initial commit'": 
           require => Package['etckeeper'],
		 }	
	}
	
class tiger::install {
	package { 'tiger':
		ensure => present,
			}
					 }

class psad::install {

#$addr =  'deepak@citrusinformatics.com;'
$strng = 'EMAIL_ADDRESSES'
$cfile = '/etc/psad/psad.conf'

    package { 'psad':
                ensure => present,
            }

    file    {  "psad.conf":

             mode    => 644,
             owner   => "root",
             group   => "root",
             ensure    => present,
             require => Package["psad"],
             path    => "/etc/psad/psad.conf",
            }

    exec    {"sed -i '/${strng}/c\EMAIL_ADDRESSES \t ${emailaddr}' '${cfile}'" :
             require   =>  Package["psad"],
             notify   =>  Service["psad"],
             before => Service["psad"], 
	    }

service { "psad":
            ensure    => "running",
            enable    => "true",
            require   => Package["psad"],
        hasrestart => true,
        hasstatus => true,
        subscribe => File["psad.conf"],
                        }
                     }   
class nmap::install {
		package { 'nmap':
		ensure => present,
				}
					}
					
class logwatch::install {
		package { 'logwatch':
		ensure => present,
					}
						}
						
class fail2ban::install {

package { 'fail2ban':
           ensure => present,
        }

service { "fail2ban":
            ensure    => "running",
            enable    => "true",
            hasrestart => true,
            hasstatus => true,
            require => File["fail2ban"],
        }
file    {  "fail2ban":
             path  => "/etc/fail2ban/jail.local",
             source => "puppet:///modules/basic/jail.conf_sample",
             mode => 644,
             owner   => "root",
             group   => "root",
             ensure    => present,
             require => Package["fail2ban"],
             notify  => Service["fail2ban"],
        }

                        }
						
class mail::install {

package { 'mutt':
           ensure => present,
        }
file {  "mail":
             path  => "/etc/init.d/system-startup-shutdown-notification.sh",
             source => "puppet:///modules/basic/system-startup-shutdown-notification.sh",
             mode => 744,
             owner   => "root",
             group   => "root",
             ensure    => present,
             require => Package["mutt"],
     }

exec { "update-rc.d system-startup-shutdown-notification.sh start 98 2 3 4 5 . stop 02 0 1 6 ." :
           require => File['mail'],
     }
					}						

class ssh::install {
$ans =  'no'
$strngs = 'PermitRootLogin'
$file2 = '/etc/ssh/sshd_config'

package { 'ssh':
           ensure => present,
        }

service { "ssh":
            ensure    => "running",
            enable    => "true",
            require   => Exec["change"],
            hasrestart => true,
            hasstatus => true,
        }

file {  "ssh":
             mode    => 644,
             owner   => "root",
             group   => "root",
             ensure    => present,
             require => Package["ssh"],
             path    => "/etc/ssh/sshd_config",
     }
	 
exec {"change":
             command => "sed -i '/${strngs}/c\PermitRootLogin \t ${ans}' '${file2}'",
             require   =>  File["ssh"],
             notify   =>  Service["ssh"],
     }
				    }
					
class whoopsie::remove  { 
package { 'whoopsie':
    ensure => purged,
		}						
						}		

class basic ($emailaddr){
             include etckeeper::install
             include tiger::install
			 include psad::install
             include nmap::install
             include logwatch::install 			 
			 include fail2ban::install
			 include whoopsie::remove 
			 include mail::install
             include ssh::install
			}

