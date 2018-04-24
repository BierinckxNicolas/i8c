#!/bin/bash
# installEclipseInstaller.sh
# Installs the Eclipse installer under /opt/eclipse
# Execute this script as user vagrant

cd /tmp

if [ ! -d /opt/eclipse ]; then
    sudo mkdir /opt/eclipse && sudo chown -R vagrant:vagrant /opt/eclipse
fi

wget http://eclipsemirror.itemis.de/eclipse/oomph/epp/oxygen/R/eclipse-inst-linux64.tar.gz
gunzip eclipse-inst-linux64.tar.gz

cd /opt/eclipse

tar -xvf /tmp/eclipse-inst-linux64.tar
