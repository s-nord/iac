#!/bin/bash
clear
workdir=$(cd `dirname $0` && pwd)
cd $workdir

id=30179271
token=$(cat $workdir/../terraform/terraform.tfvars | grep do_token | awk -F  "\"" '{print $2}')

# Get all keys
# curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $token" "https://api.digitalocean.com/v2/account/keys?per_page=10000"

# Retrieve
curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $token" "https://api.digitalocean.com/v2/account/keys/$id"
