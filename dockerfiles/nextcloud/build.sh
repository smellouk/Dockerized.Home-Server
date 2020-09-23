#!/bin/bash
working_dir="./dockerfiles/nextcloud"
docker build -t nextcloud:smb -f $working_dir/Dockerfile $working_dir
