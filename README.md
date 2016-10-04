Backend Developer with DevOps Technical Test
=======

Perl Version
------------
By Nicolas Boisselier <nicolas.boisselier@gmail.com>

Complete in 8 hours.

I choosed puppet as a deployment tool (manifests/default.pp).

### Download ###
~~~
git clone git@github.com:nboisselier/15gifts.git
~~~

### Deployment (default web port 8080) ###
~~~
vagrant up
~~~

### Test ###
~~~
# Web access (port changeable in Vagrantfile)
curl -s [http://127.0.0.1:8080](http://127.0.0.1:8080)

# Shell
vagrant ssh

# Local document root (changeable in files/etc/nginx/sites-available/default)
ls -lh files/var/www/
~~~

### Development ###
You can edit any files out of vagrant direcly on the local host (files/var/www/).

~~~
├── README.md
├── Vagrantfile
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
