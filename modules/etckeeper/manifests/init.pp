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
        onlyif => "/bin/grep '${line2}' '${file}' | /bin/grep '^#' | /usr/bin/wc -l"
    }
    exec { "/bin/sed -i -e'/${line1}/s/\(.\+\)$/#\1/' '${file}'" :
        onlyif => "/usr/bin/test `/bin/grep '${line1}' '${file}' | /bin/grep -v '^#' | /usr/bin/wc -l` -ne 0"
    }

    exec { "/bin/sed -i -e'/${line3}/s/\(.\+\)$/#\1/' '${file}'" :
        onlyif => "/usr/bin/test `/bin/grep '${line3}' '${file}' | /bin/grep -v '^#' | /usr/bin/wc -l` -ne 0"
    }
    exec { "/bin/sed -i -e'/${line4}/s/\(.\+\)$/#\1/' '${file}'" :
        onlyif => "/usr/bin/test `/bin/grep '${line4}' '${file}' | /bin/grep -v '^#' | /usr/bin/wc -l` -ne 0"
    }
 
	exec { "etckeeper init": 
           require => Package['etckeeper'],
		 }

	exec { "etckeeper commit -am 'Initial commit'": 
           require => Package['etckeeper'],
		 }
	
	}
	
class etckeeper {
             include etckeeper::install
                }
