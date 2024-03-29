#!/bin/bash
set -x

source ~/source/devstack/openrc admin admin
cd ~/source/senlin/
git checkout master
git pull
sudo pip install -r requirements.txt
sudo ~/source/template/senlin/install.sh
#sudo rm -rf /usr/lib/python2.7/site-packages/senlin
#sudo python setup.py develop

old_id = `keystone endpoint |grep 8778 |cut -d' ' -f2`
if [[ -n $old_id ]];then
  keystone endpoint-delete $old_id
fi
sudo ./tools/setup-service

export MYSQL_ROOT_PW='Passw0rd'
export MYSQL_SENLIN_PW='senlin'
sudo ./tools/senlin-db-recreate

cd ~/source/python-senlinclient
sudo python setup.py develop

