#!/bin/bash
set -eo pipefail

. utils.sh

check_env_var "CONJUR_APPLIANCE_IMAGE"
check_env_var "CONJUR_NAMESPACE"
check_env_var "AUTHENTICATOR_ID"
check_env_var "CONJUR_APPLIANCE_URL"
check_env_var "OSHIFT_CONJUR_ADMIN_USERNAME"

if [[ ! -f "${FOLLOWER_SEED}" ]] && [[ ! "${FOLLOWER_SEED}" =~ ^http[s]?:// ]]; then
    echo "ERROR! Follower seed '${FOLLOWER_SEED}' does not point to a file or a seed service!"
    exit 1
fi