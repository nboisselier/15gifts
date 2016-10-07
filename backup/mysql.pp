# export DEBIAN_FRONTEND=noninteractive; debconf-set-selections < /etc/debconf-set-selections.txt ;apt-get install -qqy mysql-server
Exec { path => '/bin:/usr/bin:/sbin:/usr/sbin'}
$mysql_password = 'change_me'
exec { 'upgrade':
  command => 'apt-get update -qqy && apt-get upgrade -qqy',
}
->
file { '/etc':
  ensure  => directory,
  owner   => 'root',
  group   => 'root',
  recurse => 'remote',
  source  => '/vagrant/files/etc',
}
->
file { '/etc/debconf-set-selections.txt':
  mode    => '0600',
  content => "mysql-server-5.5         mysql-server/root_password       password ${mysql_password}
mysql-server-5.5         mysql-server/root_password_again         password ${mysql_password}
"
}
->
file { '/root/.my.cnf2':
  content => "### MANAGED BY PUPPET ###
[client]
password=${mysql_password}
"
}
->
exec { '/etc/mysql-server-install.sh': }
# NB 07.10.16 package { 'mysql-server' :
# NB 07.10.16   ensure          => 'present',
# NB 07.10.16   responsefile    => '/etc/debconf-set-selections.txt',
# NB 07.10.16 }
