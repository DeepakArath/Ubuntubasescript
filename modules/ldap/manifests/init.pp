class ldap::install {

exec {"ldap1":
       command => "echo libnss-ldap shared/ldapns/ldap-server   string ldap://10.180.156.157 | debconf-set-selections",
        before => Exec ["ldap2"], 
	 }

exec {"ldap2":
       command => "echo libnss-ldap shared/ldapns/base-dn   string dc=ds,dc=netspective,dc=com | debconf-set-selections",
        require => Exec ["ldap1"],
         }
exec {"ldap3":
       command => "echo libnss-ldap shared/ldapns/ldap_version  select  3 | debconf-set-selections",
        require => Exec ["ldap2"],
         }
exec {"ldap4":
       command => "echo libnss-ldap libnss-ldap/dbrootlogin boolean true | debconf-set-selections",
        require => Exec ["ldap3"],
         }
exec {"ldap5":
       command => "echo libnss-ldap libnss-ldap/dblogin boolean false | debconf-set-selections",
        require => Exec ["ldap4"],
         }
exec {"ldap6":
       command => "echo libnss-ldap libnss-ldap/rootbinddn  string  cn=admin,dc=ds,dc=netspective,dc=com | debconf-set-selections",
        require => Exec ["ldap5"],
         }

package { 'libnss-ldap':
       ensure => present,
        require => Exec["ldap6"], 
        }

exec {"ldap7":
       command => "auth-client-config -t nss -p lac_ldap",
       require => Package ["libnss-ldap"],
        }
exec {"ldap8":
       command => "echo libpam-runtime  libpam-runtime/profiles multiselect     unix, ldap | debconf-set-selections",
	require => Exec["ldap7"],
}

$pamfile = '/etc/pam.d/common-password'
#$pamvalue = 'password        [success=1 user_unknown=ignore default=die]     pam_ldap.so use_authtok try_first_pass'
#$newvalue = 'password 	      [success=1 user_unknown=ignore default=die]     pam_ldap.so try_first_pass'


file { "/etc/pam.d/common-password": ensure => present, }

exec {"ldap9":
             command => "sed -i 's/use_authtok/ /g' '${pamfile}'",
             subscribe  =>  File["/etc/pam.d/common-password"],             
 	     require => Exec["ldap8"],
     }

file    {  "common-session":
             path  => "/etc/pam.d/common-session",
             source => "puppet:///modules/ldap/common-session",
             mode => 644,
             owner   => "root",
             group   => "root",
             ensure    => present,
             require => Exec["ldap9"],
        }
$ccfile = '/etc/ldap.conf'
$ccfile2 = '/etc/hosts'
$cstr1 = 'host 127.0.0.1'
$cstr2 = 'prime.ds.netspective.com slave1.ds.netspective.com'
$cstr3 = 'cn=admin,dc=ds,dc=netspective,dc=com'
$cstr4 = 'rootbinddn cn=manager,dc=example,dc=net'
$cstr5 = 'port 389'
$cstr6 = '636'
$cstr8 = 'no'
$cstr9 = 'tls_checkpeer yes'
$cstr10 = 'ssl start_tls'
$cstr11 = 'ssl on'
$cstr12 = 'port 389'
$cstr13 = 'uri ldapi:'
$cstr14 = 'dc=ds,dc=netspective,dc=com'
$cstr15 = 'base dc=example,dc=net'

    
exec {"ldap10":
             command => "sed -i '/${cstr1}/c\host \t ${cstr2}' '${ccfile}'",
             require => Exec["ldap9"],
     }  

exec {"ldap11":
             command => "sed -i '/${cstr4}/c\rootbinddn \t ${cstr3}' '${ccfile}'",
             require => Exec["ldap10"],
     }

exec {"ldap17":
             command => "sed -i '/${cstr5}/c\port \t ${cstr6}' '${ccfile}'",
             require => Exec["ldap16"],
     }

exec {"ldap22":
             command => "sed -i '/${cstr9}/c\tls_checkpeer \t ${cstr8}' '${ccfile}'",
             require => Exec["ldap21"],
     }

exec { "ldap14" :
        command => "/bin/sed -i -e'/${cstr9}/s/#\+//' '${ccfile}'",
        onlyif => "/bin/grep '${cstr9}' '${ccfile}' | /bin/grep '^#' | /usr/bin/wc -l",
        require => Exec["ldap12"],
     }
exec { "ldap15" :
        command => "/bin/sed -i -e'/${cstr10}/s/#\+//' '${ccfile}'",
        onlyif => "/bin/grep '${cstr10}' '${ccfile}' | /bin/grep '^#' | /usr/bin/wc -l",
        require => Exec["ldap14"],
     }
exec { "ldap16" :
        command => "/bin/sed -i -e'/${cstr11}/s/#\+//' '${ccfile}'",
        onlyif => "/bin/grep '${cstr11}' '${ccfile}' | /bin/grep '^#' | /usr/bin/wc -l",
        require => Exec["ldap15"],
     }
exec { "ldap12" :
        command => "/bin/sed -i -e'/${cstr12}/s/#\+//' '${ccfile}'",
        onlyif => "/bin/grep '${cstr12}' '${ccfile}' | /bin/grep '^#' | /usr/bin/wc -l",
        require => Exec["ldap11"],
     }

exec { "ldap18" :
        command => "/bin/sed -i -e'/${cstr13}/s/\(.\+\)$/#\1/' '${ccfile}'",
        onlyif => "/usr/bin/test `/bin/grep '${cstr13}' '${ccfile}' | /bin/grep -v '^#' | /usr/bin/wc -l` -ne 0",
        require => Exec["ldap17"],
     }

exec { "ldap19" :
       command => "echo 10.177.14.168   prime.ds.netspective.com >> '${ccfile2}'",
      require => Exec ['ldap18'],
     }

exec { "ldap20" :
       command => "echo 10.177.7.163    slave1.ds.netspective.com >> '${ccfile2}'",
      require => Exec ['ldap19'],
     }
exec {"ldap21":
             command => "sed -i '/${cstr15}/c\base \t ${cstr14}' '${ccfile}'",
             require => Exec["ldap20"],
     }


}

class ldap {
             include ldap::install
           }
