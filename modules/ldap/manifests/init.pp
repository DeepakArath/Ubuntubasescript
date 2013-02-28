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
    }

class ldap {
             include ldap::install
           }
