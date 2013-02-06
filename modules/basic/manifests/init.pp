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
	 }
    exec { "/bin/sed -i -e'/${line1}/s/\(.\+\)$/#\1/' '${file}'" :
        onlyif => "/usr/bin/test `/bin/grep '${line1}' '${file}' | /bin/grep -v '^#' | /usr/bin/wc -l` -ne 0",
         require => Package['etckeeper'],
         }

    exec { "/bin/sed -i -e'/${line3}/s/\(.\+\)$/#\1/' '${file}'" :
        onlyif => "/usr/bin/test `/bin/grep '${line3}' '${file}' | /bin/grep -v '^#' | /usr/bin/wc -l` -ne 0",
         require => Package['etckeeper'],
         }
    exec { "/bin/sed -i -e'/${line4}/s/\(.\+\)$/#\1/' '${file}'" :
        onlyif => "/usr/bin/test `/bin/grep '${line4}' '${file}' | /bin/grep -v '^#' | /usr/bin/wc -l` -ne 0",
         require => Package['etckeeper'],
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

$addr =  'deepak@citrusinformatics.com;'
$strng = 'EMAIL_ADDRESSES'
$cfile = '/etc/psad/psad.conf'

    package { 'psad':
                ensure => present,
            }
    service { "psad":
            ensure    => "running",
            enable    => "true",
            require   => Package["psad"],
        hasrestart => true,
        hasstatus => true,
        subscribe => File["psad.conf"],
			}

    file    {  "psad.conf":

             mode    => 644,
             owner   => "root",
             group   => "root",
             ensure    => present,
             require => Package["psad"],
             path    => "/etc/psad/psad.conf",
            }

    exec    {"sed -i '/${strng}/c\EMAIL_ADDRESSES \t ${addr}' '${cfile}'" :
             require   =>  Package["psad"],
              notify   =>  Service["psad"],
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
						}

class whoopsie::remove  { 
package { 'whoopsie':
    ensure => purged,
		}						
						}		


class basic {
             include etckeeper::install
             include tiger::install
			 include psad::install
             include nmap::install
             include logwatch::install 			 
			 include fail2ban::install
			 include whoopsie::remove 
			 
			}

