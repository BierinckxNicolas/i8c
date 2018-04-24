#!/bin/bash
# installPostgresql.sh
# Installs Postgresql v9.6
# Execute this script as user root

# Install EPEL repo, required for pgadmin4 dependencies
yum install -y epel-release

# Based on instructions on https://www.postgresql.org/download/linux/redhat/
yum install -y  https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
yum install -y postgresql96 postgresql96-server pgadmin4-v1
/usr/pgsql-9.6/bin/postgresql96-setup initdb
# Allow remote login via password
mv /var/lib/pgsql/9.6/data/pg_hba.conf /var/lib/pgsql/9.6/data/pg_hba.conf.bak
sed s/ident$/md5/ </var/lib/pgsql/9.6/data/pg_hba.conf.bak >/var/lib/pgsql/9.6/data/pg_hba.conf
# Increase max_connections to allow enough connections for WSO2 IS and APIM
mv /var/lib/pgsql/9.6/data/postgresql.conf /var/lib/pgsql/9.6/data/postgresql.conf.bak
sed "s/max_connections.*/max_connections = 500/" </var/lib/pgsql/9.6/data/postgresql.conf.bak >/var/lib/pgsql/9.6/data/postgresql.conf
systemctl enable postgresql-9.6
systemctl start postgresql-9.6

# Install the database objects
sudo -u postgres psql -f /vagrant/installPostgresql.sql

