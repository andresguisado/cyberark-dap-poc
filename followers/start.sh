#!/bin/bash
set -euo pipefail

./stop.sh

./0_check_dependencies.sh
./1_prepare_conjur_namespace.sh

if [[ "${CONJUR_MASTER_DNS}" = "false" ]]; then
    ./2_create_conjur_master_service.sh
fi

./3_deploy_conjur_followers.sh
