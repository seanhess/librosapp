#!/bin/bash

# POST-sync installation

domain=$1

echo ""
echo "===================="
echo "DEPLOY"
echo "===================="

#you don't need to build, it's already compiled locally
#make build
make install
#chown www-data:www-data -R .

# set up rethinkdb
cp config/rethinkdb.upstart.conf /etc/init/rethinkdb.conf
stop rethinkdb
start rethinkdb

# set up node server
sudo cp config/server.upstart.conf /etc/init/libros.conf
sudo stop libros
sudo start libros

# set up nginx
sudo cp config/nginx.conf /etc/nginx/conf.d/libros.conf
sudo service nginx stop
sudo service nginx start

