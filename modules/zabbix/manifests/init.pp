class zabbix::install {

$flzab = '/usr/local/etc/zabbix_agentd.conf'
$value1 = 'Server'
$value2 = 'Hostname'
$value3 = '10.177.10.192'
$value4 = 'prime.ds.netspective.com'


group { "zabbix":
       ensure => "present",
      }

exec {"zab0":
       command => "sudo useradd -s /sbin/nologin zabbix -g zabbix",       
     }


#user  { "zabbix":
#       ensure  => present,
#       groups => zabbix,
#      }

exec {"zab1":
       command => "mkdir -p /mnt/setup",
       require => Exec["zab0"],
     }

exec {"zab2":
       command => "wget http://www.zabbix.com/downloads/2.0.0/zabbix_agents_2.0.0.linux2_6_23.amd64.tar.gz",
       require => Exec["zab1"],
       timeout => '0',
     }

exec {"zab3":
       command => "/bin/tar -xvzf zabbix_agents_2.0.0.linux2_6_23.amd64.tar.gz",
       require => Exec["zab2"],
     }

exec {"zab4":
       command => "cp bin/* /usr/local/bin/",
     require => Exec["zab3"],
     }
exec {"zab5":
       command => "cp sbin/* /usr/local/sbin",
       require => Exec["zab4"],	
     }

exec {"zab6":
       command => "wget http://ncu.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.0.2/zabbix-2.0.2.tar.gz",
       require => Exec["zab5"],
       timeout => '0',
     }

exec {"zab7":
       command => "tar -zxvf zabbix-2.0.2.tar.gz",
       require => Exec["zab6"],
     }

exec {"zab8":
       command => "sudo cp zabbix-2.0.2/conf/zabbix_agentd.conf /usr/local/etc/",
       require => Exec["zab7"],
     }

exec {"zab9":
             command => "sed -i '/${value1}/c\Server \t ${value3}' '${flzab}'",
             require =>  Exec["zab8"],            
     }

exec {"zab10":
             command => "sed -i '/${value2}/c\Hostname \t ${value4}' '${flzab}'",
             require =>  Exec["zab9"],
     }

exec {"zab11":
       command => "sudo ufw allow proto tcp from 10.177.10.192 to any port 10050",
       require => Exec["zab10"],
     }

exec {"zab12":
       command => "cp zabbix-2.0.2/misc/init.d/debian/zabbix-agent /etc/init.d/",
       require => Exec["zab11"],
     }
exec {"zab13":
       command => "sudo service zabbix-agent start",
       require => Exec["zab12"],
     }
exec {"zab14":
       command => "rm -rf zabbix* sbin/ bin/",
       require => Exec["zab13"],
     }

}
class zabbix {
             include zabbix::install
             } 

