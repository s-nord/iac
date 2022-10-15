#!/bin/bash

workdir=$(cd `dirname $0` && pwd)
cd $workdir

server=$1
ansible_vars=$workdir/../ansible/vars.yml

enviroment=$(cat $ansible_vars | sed 's:#.*$::g' | grep enviroment | awk '{print $2}')

if [ -z "$server" ]; then
    echo 'Not enough parameters: deploy.sh $server'
    exit
fi

ansible-playbook --vault-password-file ~/.ansible/rebrain-vault.pwd -i ../$enviroment/export/inv.ini ../ansible/$server.yml
