#$ipaddr = "Enter server IP Address here"



Exec {
    path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
}

# If you want to run this manifest for a specified system, put the system name instead of default. Default means it will run all the systems.
# If you don't want to install any of this modules , Please do delete that line and execute this manifest.


node default {

## The following variables are used in configuring S3CMD ##########

$accessskey = 'Add Amazone access key here'
$secretkey = 'Add secret key here'
$encryptionpass = 'Encryption password here'

####################################################################


$ipaddress = 'Add Server IP address here. this will be passed to NFS module'

$psademail = 'Add Email alert address for PSAD here'

$perconapasswd = 'Add percona server password here' 


class { 'basic': 
	emailaddr => $psademail,
      }

class { 'mysql': 
	password => $perconapasswd,
      }

class { 'nfs':  
	ipaddr => $ipaddress,
      } 

include nfscli

class { 's3cmd':

	aceskey => $accessskey,
	secrtkey => $secretkey,
	encryptpass => $encryptionpass,
	
      }
include ldap
include zabbix  
}
