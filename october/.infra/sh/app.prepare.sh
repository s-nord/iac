#!/bin/bash

workdir=$(cd `dirname $0` && pwd)
cd $workdir

ansible_vars=$workdir/../ansible/vars.yml

enviroment=$(cat $ansible_vars | sed 's:#.*$::g' | grep enviroment | awk '{print $2}')

ansible-playbook --vault-password-file ~/.ansible/rebrain-vault.pwd -i ../$enviroment/export/inv.ini ../ansible/app.prepare.yml
