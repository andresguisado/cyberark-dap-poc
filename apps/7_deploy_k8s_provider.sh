#!/bin/bash 
set -eo pipefail

. utils.sh


main() {
  
  deploy_k8s_provider_app
  announce "K8s provider app deployed."
}


deploy_k8s_provider_app() {
  $cli delete --ignore-not-found \
     deployment/k8s-provider-app \
     secret/db-credentials
  announce "Deploying K8s provider app."
  

  sed -e "s#{{ K8S_PROVIDER_IMAGE }}#$CONJUR_K8S_PROVIDER_IMAGE#g" "./$PLATFORM/k8s-provider.yml" |
    sed -e "s#{{ DEMOAPP_IMAGE }}#$DEMOAPP_IMAGE#g" |
    sed -e "s#{{ K8S_PROVIDER_APP_CONTAINER_NAME }}#$K8S_PROVIDER_APP_CONTAINER_NAME#g" |
    sed -e "s#{{ DB_PLATFORM }}#$DEMOAPPS_DB#g" |
    sed -e "s#{{ DEMOAPPS_NAMESPACE }}#$DEMOAPPS_NAMESPACE#g" |
    sed -e "s#{{ K8S_PROVIDER_SERVICEACCOUNT }}#$K8S_PROVIDER_SERVICEACCOUNT#g" |
    sed -e "s#{{ CONJUR_APPLIANCE_URL }}#$CONJUR_APPLIANCE_URL#g" |
    sed -e "s#{{ CONJUR_AUTHN_URL }}#$CONJUR_AUTHN_URL#g" |
    sed -e "s#{{ CONJUR_ACCOUNT }}#$CONJUR_ACCOUNT#g" |
    sed -e "s#{{ K8S_PROVIDER_CONJUR_AUTHN_LOGIN }}#$K8S_PROVIDER_CONJUR_AUTHN_LOGIN#g" |
    $cli apply -f -
}


main $@
