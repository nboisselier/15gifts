package { [
  'mysql-server'
  'mysql-server-5.5'
] :
  ensure => 'purged',
}
# NB 07.10.16 ->file{[
# NB 07.10.16   '/var/lib/mysql',
# NB 07.10.16   '/var/log/mysql',
# NB 07.10.16   '/etc/mysql',
# NB 07.10.16 ]:
# NB 07.10.16   ensure  => 'absent',
# NB 07.10.16   recurse => 'true',
# NB 07.10.16   force   => 'true',
# NB 07.10.16 }
