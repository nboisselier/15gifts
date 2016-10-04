Backend Developer with DevOps Technical Test
=======

Perl Version
------------
By Nicolas Boisselier <nicolas.boisselier@gmail.com>

Complete in 8 hours.

I choosed puppet as a deployment tool (manifests/default.pp).
I tested the project on Yosemite MacBook Pro 2010 (2,4 GHz Intel Core 2 Duo - 4GB).

Instructions
------------

### Download ###
~~~
git clone git@github.com:nboisselier/15gifts.git
~~~

### Deployment ###
~~~
vagrant up
~~~

### Test ###
~~~
# Web access from vagrant host (port changeable in Vagrantfile, 80 on)
curl -s [http://127.0.0.1:8080](http://127.0.0.1:8080)

# Shell
vagrant ssh

# Local document root (changeable in files/etc/nginx/sites-available/default)
ls -lh files/var/www/
~~~

### Development ###
You can edit any files out of vagrant direcly on the local host (files/var/www/).

~~~
├── Vagrantfile # change local port
├── files # System
│   ├── etc
│   │   ├── init.d
│   │   │   └── perl-fcgi
│   │   ├── mysql
│   │   │   └── conf.d
│   │   │       └── bind-address.cnf
│   │   └── nginx
│   │       └── sites-available
│   │           └── default
│   └── var
│       └── www # Document root
│           ├── default.css
│           └── index.pl
└── manifests # Puppet deployment manifest
    └── default.pp
 ~~~
