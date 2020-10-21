#!/bin/bash

. `dirname "$0"`/../../.env

echo "[INFO] Starting DAP master"
docker-compose up -d dap-master

echo "[INFO] Configuring DAP master"
# The web interface do not start before running this command
docker-compose exec dap-master evoke configure master --accept-eula --hostname $DAP_FQDN --master-altnames $DAP_ALTNAMES --admin-password $DAP_ADMIN_PASSWORD $DAP_ACCOUNT




