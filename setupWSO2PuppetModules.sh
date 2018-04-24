#!/bin/bash
# This script automates most of the instructions on:
# https://docs.wso2.com/display/AM210/Using+Puppet+Modules+to+Set+up+WSO2+API-M+with+Pattern+7#bc789eccf0234bef919aa80f694fabf3
# https://github.com/wso2/puppet-apim/tree/master/wso2is_prepacked
# https://github.com/wso2/puppet-apim/tree/master/wso2am_runtime
# and includes some improvements:
# - Sets up all Puppet artefacts and dependencies
# - Downloads the Puppet Module WSO2 puppet-base with support for CentOS
# - Automatically downloads the correct WSO2 distributions & Postgresql driver
#
PUPPET_HOME_SUB_DIR=puppet_home
GITHUB_SUB_DIR=github
MANIFESTS_SUB_DIR=manifests
HIERADATA_SUB_DIR=hieradata
MODULES_SUB_DIR=modules

if [ ! -d $PUPPET_HOME_SUB_DIR ]; then
  mkdir $PUPPET_HOME_SUB_DIR
fi
pushd $PUPPET_HOME_SUB_DIR

if [ ! -d $GITHUB_SUB_DIR ]; then
  mkdir $GITHUB_SUB_DIR
fi

if [ ! -d $MANIFESTS_SUB_DIR ]; then
  mkdir $MANIFESTS_SUB_DIR
fi

if [ ! -d $HIERADATA_SUB_DIR ]; then
  mkdir $HIERADATA_SUB_DIR
fi

if [ ! -d $MODULES_SUB_DIR ]; then
  mkdir $MODULES_SUB_DIR
fi

git clone -n https://github.com/wso2/puppet-common $GITHUB_SUB_DIR/puppet-common
git clone -n https://github.com/wso2/puppet-base $GITHUB_SUB_DIR/puppet-base
git clone -n https://github.com/wso2/puppet-apim $GITHUB_SUB_DIR/puppet-apim

# Select correct versions
pushd $GITHUB_SUB_DIR/puppet-common
# This specific version fixes the Error: Could not find class wso2base::java for ...
git checkout c6fbc1301df6561198c31b85352d11bf50408a6a
popd

pushd $GITHUB_SUB_DIR/puppet-base
# This specific version supports installing WSO2 APIM as a service on CentOS (including corresponding bug fix)
git checkout 680189ea29d2a0e774fc8412a0234cfbc0629074
popd

pushd $GITHUB_SUB_DIR/puppet-apim
# Avoid that Windows changes LF in CRLF upon checkout, otherwise wso2server.sh template will generate
# non-functioning startup script.
git config --local core.autocrlf false
git checkout v2.1.0
popd

# create setup
mkdir $MODULES_SUB_DIR/wso2base
cp -r $GITHUB_SUB_DIR/puppet-base/* $MODULES_SUB_DIR/wso2base
cp -r $GITHUB_SUB_DIR/puppet-apim/wso2am_runtime $MODULES_SUB_DIR
cp -r $GITHUB_SUB_DIR/puppet-apim/wso2is_prepacked $MODULES_SUB_DIR

cp $GITHUB_SUB_DIR/puppet-common/manifests/site.pp $MANIFESTS_SUB_DIR

pushd $MODULES_SUB_DIR/wso2am_runtime/files
curl --header "Referer: https://wso2.com/api-management/download-thank-you/" https://product-dist.wso2.com/products/api-manager/2.1.0/wso2am-2.1.0.zip -o wso2am-2.1.0.zip
popd

pushd $MODULES_SUB_DIR/wso2is_prepacked/files
# Note that the pre-packed IS is downloaded here, not the standard IS!
curl http://product-dist.wso2.com/downloads/api-manager/2.1.0/identity-server/wso2is-5.3.0.zip -o wso2is-5.3.0.zip
popd

curl https://jdbc.postgresql.org/download/postgresql-42.1.4.jar -o postgresql-42.1.4.jar
cp postgresql-42.1.4.jar $MODULES_SUB_DIR/wso2is_prepacked/files/configs/repository/components/lib
cp postgresql-42.1.4.jar $MODULES_SUB_DIR/wso2am_runtime/files/configs/repository/components/lib

#curl --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.rpm
echo "Download jdk-8u144-linux-x64.tar.gz from Oracle's website and copy it into the folder "$PUPPET_HOME_SUB_DIR"/"$MODULES_SUB_DIR"/wso2base/files. This task is not automated because the Oracle site requires you to register and login. This version of the JDK is required because of an issue with JDK1.8.0_151 and JDK1.8.0_152"

popd
