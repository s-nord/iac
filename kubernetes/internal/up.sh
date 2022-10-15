#!/bin/bash
clear
workdir=$(cd `dirname $0` && pwd)
cd $workdir

source $workdir/vars.env
source $workdir/func.sh

# nfs_provisioner
# ingress
ingress_getip
# prometheus
efk
# mysql

# wordpress # Don't use it. Use deploy in CI/CD
