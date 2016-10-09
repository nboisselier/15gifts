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
file { '/etc':
  ensure => directory,
  owner => 'root',
  group => 'root',
  recurse => 'remote',
  source => '/vagrant/files/etc',
}
->
file { '/var/www':
  ensure => directory,
  owner => 'www-data',
  group => 'www-data',
  recurse => 'remote',
  source => '/vagrant/files/var/www',
}
->
package {[
  'fcgiwrap',
  'nginx',
  'spawn-fcgi',
  'libfcgi-perl',
  'wget',
  'mysql-server',
]:
  ensure => 'latest',
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
  ensure => 'running',
  enable => true,
}
