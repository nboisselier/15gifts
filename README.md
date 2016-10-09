Backend Developer with DevOps Technical Test
=======

Perl Version
------------
By Nicolas Boisselier <nicolas.boisselier@gmail.com>

Completed in 8 hours.

I choosed puppet as a deployment tool (manifests/default.pp).

Quick install:

~~~
git clone git@github.com:nboisselier/15gifts.git && cd 15gifts && vagrant up && curl localhost:8080
~~~

Instructions
------------

### Download ###
~~~
git clone https://github.com/nboisselier/15gifts.git && 15gifts/
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
