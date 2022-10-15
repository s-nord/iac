#!/bin/bash

workdir=$(cd `dirname $0` && pwd)
cd $workdir

server=$1
ansible_vars=$workdir/../ansible/vars.yml

enviroment=$(cat $ansible_vars | sed 's:#.*$::g' | grep enviroment | awk '{print $2}')

if [ -z "$server" ]; then
    echo 'Not enough parameters: config.sh $server'
    exit
fi

ansible-playbook --vault-password-file ~/.ansible/rebrain-vault.pwd --tags config -i ../$enviroment/export/inv.ini ../ansible/$server.yml
