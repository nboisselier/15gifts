##############################################################################
#
# Puppet manifest
#
# Perl Version
# Backend Developer with DevOps Technical Test
#
# By Nicolas Boisselier <nicolas.boisselier@gmail.com>
# Date: 04.10.16
#
##############################################################################
$mysql_password = 'change_me'

file { '/etc':
  ensure  => directory,
  owner   => 'root',
  group   => 'root',
  recurse => 'remote',
  source  => '/vagrant/files/etc',
}
->
file { '/var':
  ensure  => directory,
  owner   => 'www-data',
  group   => 'www-data',
  recurse => 'remote',
  source  => '/vagrant/files/var',
}
->
file { '/var/www/config.pl':
  group   => 'www-data',
  mode    => '0640',
  content => "### MANAGED BY PUPPET ###
our @DBI = ('DBI:mysql:dbname=mysql;mysql_socket=/var/run/mysqld/mysqld.sock','root','${mysql_password}');
1;
",
}
->
package {[
  'fcgiwrap',
  'nginx',
  'spawn-fcgi',
  'libfcgi-perl',
  'wget',
]:
  ensure       => 'latest',
}
->
exec { '/usr/bin/wget http://nginxlibrary.com/downloads/perl-fcgi/fastcgi-wrapper -O /usr/bin/fastcgi-wrapper.pl && /bin/chmod 0755 /usr/bin/fastcgi-wrapper.pl':
  creates => '/usr/bin/fastcgi-wrapper.pl'
}
->
service { [
  'nginx',
  'perl-fcgi',
]:
  ensure => 'running'
}
->
file { '/root/.my.cnf':
  content => "### MANAGED BY PUPPET ###
[client]
password=${mysql_password}
"
}
->
file { '/etc/debconf-set-selections.txt':
  content => "### MANAGED BY PUPPET ###
mysql-server-5.5        mysql-server/root_password_again     password ${mysql_password}
mysql-server-5.5        mysql-server/root_password           password ${mysql_password}
mysql-server-5.5        mysql-server-5.5/root_password_again password ${mysql_password}
mysql-server-5.5        mysql-server-5.5/root_password       password ${mysql_password}
"
}
->
package { 'mysql-server' :
  ensure       => 'installed',
  responsefile => '/etc/debconf-set-selections.txt',
  require      => File['/etc'],
}
# NB 07.10.16 ->exec { 'debconf-set-selections /etc/debconf-set-selections.txt && apt-get install -qqy mysql-server': environment => 'DEBIAN_FRONTEND=noninteractive',path=>'/bin:/usr/bin:/sbin:/usr/sbin'}
