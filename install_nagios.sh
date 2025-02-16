#!/bin/bash
sudo apt update -y
sudo apt install -y wget build-essential apache2 php openssl perl make php-gd libgd-dev libapache2-mod-php libperl-dev libssl-dev daemon autoconf libc6-dev libmcrypt-dev libssl-dev libnet-snmp-perl gettext unzip

cd /tmp
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.6.tar.gz

sudo useradd nagios
sudo groupadd nagcmd
sudo usermod -a -G nagcmd nagios

tar -xzf nagios-4.4.6.tar.gz
cd nagios-4.4.6

sudo ./configure --with-httpd-conf=/etc/apache2/sites-enabled
sudo make all
sudo make install
sudo make install-init
sudo make install-commandmode
sudo make install-config
sudo /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-enabled/nagios.conf

sudo a2enmod rewrite
sudo a2enmod cgi
sudo systemctl restart apache2

cd /tmp
wget https://nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz
tar -xzf nagios-plugins-2.3.3.tar.gz
cd nagios-plugins-2.3.3
sudo ./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
sudo make
sudo make install

sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

sudo systemctl enable --now nagios.service
sudo systemctl restart apache2.service

#sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
##enter nagios password for webUI ## 
