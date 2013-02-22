#$ipaddr = "Enter server IP Address here"



Exec {
    path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
}

# If you want to run this manifest for a specified system, put the system name instead of default. Default means it will run all the systems.
# If you don't want to install any of this modules , Please do delete that line and execute this manifest.


node default {
$ipaddress = '192.168.1.102'
$psademail = 'deepak@citrusinformatics.com;'
$perconapasswd = '123456' 
class { 'basic': 
emailaddr => $psademail,
}
class { 'mysql': 
password => $perconapasswd,
}
class { 'nfs':  
ipaddr => $ipaddress,
} 
#include nfscli
}
