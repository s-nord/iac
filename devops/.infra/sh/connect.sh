#!/bin/bash

workdir=$(cd `dirname $0` && pwd)
cd $workdir

server=$1
ansible_vars=$workdir/../ansible/vars.yml

enviroment=$(cat $ansible_vars | sed 's:#.*$::g' | grep enviroment | awk '{print $2}')

hosts=$workdir/../$enviroment/export/hosts.public

if [ -z "$server" ]; then
    echo 'Not enough parameters: connect.sh $server'
    exit
fi

ip=$(cat $hosts | grep $server | awk '{print $1}')

ssh root@$ip
