#!/bin/bash
clear
workdir=$(cd `dirname $0` && pwd)
cd $workdir

helm uninstall -n mysql mysql
helm uninstall -n wordpress wordpress 
