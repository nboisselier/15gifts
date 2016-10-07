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
# export DEBIAN_FRONTEND=noninteractive; debconf-set-selections < /etc/debconf-set-selections.txt ;apt-get install -qqy mysql-server
#
##############################################################################
$mysql_password = 'change_me'

Exec { path => '/bin:/usr/bin:/sbin:/usr/sbin'}

# NB 07.10.16 exec { 'upgrade':
# NB 07.10.16   command => 'apt-get update -qqy && apt-get upgrade -qqy',
# NB 07.10.16 }
# NB 07.10.16 ->
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
  'debconf-utils',
]:
  ensure => 'latest',
}
->exec { 'wget http://nginxlibrary.com/downloads/perl-fcgi/fastcgi-wrapper -O /usr/bin/fastcgi-wrapper.pl && chmod 0755 /usr/bin/fastcgi-wrapper.pl':
  creates => '/usr/bin/fastcgi-wrapper.pl',
  notify  => Service['perl-fcgi'],
}
->class { 'mysql_server': password => $mysql_password }


service { [ 'nginx' ]:
  ensure  => 'running',
  require => Service['perl-fcgi'],
}

service { 'perl-fcgi':
  ensure => 'running',
}
# NB 07.10.16 ->exec { 'debconf-set-selections /etc/debconf-set-selections.txt && apt-get install -qqy mysql-server': environment => 'DEBIAN_FRONTEND=noninteractive',path=>'/bin:/usr/bin:/sbin:/usr/sbin'}

class mysql_server (
  $ensure   = 'present',
  $password = '',
  $bind_address = '0.0.0.0'
) {

  file { '/etc/debconf-set-selections.txt':
    mode    => '0600',
    content => "
mysql-server-5.5        mysql-server/root_password               password ${password}
mysql-server-5.5        mysql-server/root_password_again         password ${password}
"
  }

  package { 'mysql-server' :
    ensure         => 'present',
    responsefile  => '/etc/debconf-set-selections.txt',
    require       => File['/etc/debconf-set-selections.txt'],
  }

if (false) {
  file { '/etc/mysql/conf.d/bind-address.cfg':
    require => Package['mysql-server'],
    notify  => Service['mysql'],
    content => "### MANAGED BY PUPPET ###\n[mysqld]\nbind-address = ${bind_address}\n"
  }
}

  exec { 'mysqlpasswd':
    command => "mysqladmin -u root password ${mysql_password}",
    unless  => "mysqladmin -uroot -p${mysql_password} status",
    require => Service['mysql'],
  }

  file { '/root/.my.cnf':
    require => Exec['mysqlpasswd'],
    content => "### MANAGED BY PUPPET ###\n[client]\npassword=${password}\n",
  }

  service { 'mysql':
    ensure  => 'running',
    require => Package['mysql-server'],
  }

}
