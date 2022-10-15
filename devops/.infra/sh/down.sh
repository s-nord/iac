#!/bin/bash
clear
workdir=$(cd `dirname $0` && pwd)
cd $workdir

ansible_vars=$workdir/../ansible/vars.yml
enviroment=$(cat $ansible_vars | sed 's:#.*$::g' | grep enviroment | awk '{print $2}')

function vagrant() { docker run -it  --rm -e LIBVIRT_DEFAULT_URI -v /var/run/libvirt/:/var/run/libvirt/ -v ~/.vagrant.d:/.vagrant.d -v ~/.ansible:/.ansible -v $(realpath "${PWD}"):${PWD} -w $(realpath "${PWD}") --network host vagrant:latest vagrant $1 $2; }

case $enviroment in
  vagrant)
    echo Vagrant enviroment detected
    cd ../$enviroment
    vagrant destroy --force
    cd $workdir
    ;;
  terraform)
    echo Terraform enviroment detected
    cd ../$enviroment
    terraform destroy -auto-approve
    cd $workdir
    ;;
  *)
    echo No enviroment detected
    exit
    ;;
esac
