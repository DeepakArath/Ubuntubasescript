class nginx::package
                {
		package { 'nginx':
                ensure => installed,
		     }
                file {'nginx.conf':
                path => '/etc/nginx/nginx.conf',
                ensure => present,
                mode => 0644,
                require => Package['nginx'],
                                }
                service { 'nginx':
                ensure => running,
                enable => true,
                subscribe => File['/etc/nginx/nginx.conf'],
                                require => Package['nginx'],
                                        }
                }

class nginx::configuration
                {
	$keepalive_timeout = 'keepalive_timeout'
	$gzip = 'gzip'
	$access_log = 'access_log'
	$nginx_conf = '/etc/nginx/nginx.conf'
	
				
				
				file {'error.log':
                path => '/var/log/nginx/error.log',
                ensure => present,
                require => Class["nginx::package"],
						
				}	

				 exec { "check_keepalive_timeout":
					command => "/bin/grep '${keepalive_timeout}' '${nginx_conf}'",
					logoutput => true,
					require => File['nginx.conf'],
										}			
				 exec { "check_gzip":
					command => "/bin/grep '${gzip}' '${nginx_conf}'",
					logoutput => true,
                    require => File['nginx.conf'],
                                        }
				 exec { "check_access_log":
                     command => "/bin/grep '${access_log}' '${nginx_conf}'",
                     logoutput => true,
                     require => File['nginx.conf'],
                                        }
			}


class harden_nginx
                {
                include nginx::package, nginx::configuration
                }
