#!/bin/bash
working_dir="./dockerfiles/nextcloud"
docker build -t nextcloud:smb-non-ssl -f $working_dir/DockerfileNonSsl $working_dir
