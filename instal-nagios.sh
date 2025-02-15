#!/bin/bash

apt install -y wget build-essential apache2 php openssl perl make php-gd libgd-dev libapache2-mod-php libperl-dev libssl-dev daemon autoconf libc6-dev libmcrypt-dev libssl-dev libnet-snmp-perl gettext unzip

cd /tmp
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.6.tar.gz

useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios

tar -xzf nagios-4.4.6.tar.gz
cd nagios-4.4.6

./configure --with-httpd-conf=/etc/apache2/sites-enabled
make all
make install
make install-init
make install-commandmode
make install-config
/usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-enabled/nagios.conf

a2enmod rewrite
a2enmod cgi
systemctl restart apache2

cd /tmp
wget https://nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz
tar -xzf nagios-plugins-2.3.3.tar.gz
cd nagios-plugins-2.3.3
./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
make
make install

/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

systemctl enable --now nagios.service
systemctl restart apache2.service
