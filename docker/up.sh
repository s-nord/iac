#!/bin/bash
clear
workdir=$(cd `dirname $0` && pwd)
cd $workdir

# Run EFK stack
# docker-compose --env-file ./efk.env -f ./efk.compose.yml build
docker-compose --env-file ./efk.env -p rbmdkrfinalefk -f ./efk.compose.yml up -d --no-deps --build

# Run App stack
# docker-compose --env-file ./app.env -f ./app.compose.yml build
docker-compose --env-file ./app.env -p rbmdkrfinalapp -f ./app.compose.yml up -d --no-deps --build

# docker exec app curl -s --unix-socket /var/run/control.unit.sock -X PUT -d '"/var/log/access.log"' http://localhost/config/access_log
