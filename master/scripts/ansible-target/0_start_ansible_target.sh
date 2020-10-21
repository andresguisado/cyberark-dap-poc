#!/bin/bash

. `dirname "$0"`/../../.env

echo "[INFO] Starting Ansible target"
docker-compose up -d target