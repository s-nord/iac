#!/bin/bash
clear
workdir=$(cd `dirname $0` && pwd)
cd $workdir

docker-compose --env-file ./app.env -p rbmdkrfinalapp -f ./app.compose.yml down
docker-compose --env-file ./efk.env -p rbmdkrfinalefk -f ./efk.compose.yml down
