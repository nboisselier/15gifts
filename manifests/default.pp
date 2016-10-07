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

#
# We copy files recursively from /vagrant/files
#
# Could be improved by using *.erb templates with global variables
#
# NB 06.10.16 ->
# NB 06.10.16 exec { '/usr/bin/apt-get install -qqy mysql-server':
# NB 06.10.16   creates => '/usr/sbin/mysqld',
# NB 06.10.16 }
#->
#->
#exec { '/usr/bin/debconf-set-selections /etc/debconf-set-selections.txt && /usr/bin/apt-get install -qqy mysql-server':}
file { '/root':
  ensure  => directory,
  owner   => 'root',
  group   => 'root',
  recurse => 'remote',
  source  => '/vagrant/files/root',
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
file { '/var':
  ensure  => directory,
  owner   => 'www-data',
  group   => 'www-data',
  recurse => 'remote',
  source  => '/vagrant/files/var',
}
->
package {[
  'fcgiwrap',
  'nginx',
  'spawn-fcgi',
  'libfcgi-perl',
  'wget',
  'mysql-server-5.5',
]:
  ensure       => 'latest',
  responsefile => '/etc/debconf-set-selections.txt',
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
