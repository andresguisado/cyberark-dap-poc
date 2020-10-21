#!/bin/bash 
set -eo pipefail

. utils.sh

main() {
  
  create_conjur_master_service
  create_conjur_master_endpoint
  announce "Conjur master service and endpoint created."
}


create_conjur_master_service() {

  announce "Creating conjur-master service."

  sed -e "s#{{ CONJUR_MASTER_SERVICE_NAME }}#$CONJUR_MASTER_SERVICE_NAME#g" "./yaml/dap-master-service.yml" |
  sed -e "s#{{ CONJUR_NAMESPACE }}#$CONJUR_NAMESPACE#g" |
  $cli apply -f -
}

create_conjur_master_endpoint() {

  announce "Creating conjur-master endpoint."

  sed -e "s#{{ CONJUR_MASTER_SERVICE_NAME }}#$CONJUR_MASTER_SERVICE_NAME#g" "./yaml/dap-master-endpoint.yml" |
  sed -e "s#{{ CONJUR_MASTER_IP }}#$CONJUR_MASTER_IP#g" |
  sed -e "s#{{ CONJUR_NAMESPACE }}#$CONJUR_NAMESPACE#g" |
  $cli apply -f -
}


main $@