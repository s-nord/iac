#!/bin/bash
clear
workdir=$(cd `dirname $0` && pwd)
cd $workdir

docker build -t registry.rebrainme.com/kubernetes_users_repos/330/k8s-final:deployer-fedora .
docker push registry.rebrainme.com/kubernetes_users_repos/330/k8s-final:deployer-fedora
