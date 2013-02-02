# just a list to remember what I did to set up an individual server

apt-get -y install git nginx

apt-get -y install python-software-properties python g++ make
add-apt-repository -y ppa:chris-lea/node.js
apt-get -y update
apt-get -y install nodejs npm

add-apt-repository -y ppa:rethinkdb/ppa
apt-get -y update
apt-get -y install rethinkdb
