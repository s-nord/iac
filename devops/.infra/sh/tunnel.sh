#!/bin/bash
clear
workdir=$(cd `dirname $0` && pwd)
cd $workdir

ansible_vars=$workdir/../ansible/vars.yml
enviroment=$(cat $ansible_vars | sed 's:#.*$::g' | grep enviroment | awk '{print $2}')

hosts_public=$workdir/../$enviroment/export/hosts.public
hosts_private=$workdir/../$enviroment/export/hosts.private

host=$1
port=$2

private_ip=$(cat $hosts_private | grep $host | awk '{print $1}')
public_ip=$(cat $hosts_public | grep $host | awk '{print $1}')

echo Create tunnel to $host:$port

ssh -N -L $port:$private_ip:$port root@$public_ip &
