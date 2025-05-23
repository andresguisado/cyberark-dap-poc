#!/bin/bash 
set -eo pipefail

. utils.sh


main() {
  
  deploy_goapp
  announce "Goapp deployed."
}


deploy_goapp() {
  $cli delete --ignore-not-found \
     deployment/goapp 
  announce "Deploying goapp."
  
  sed -e "s#{{ CONJUR_AUTHENTICATOR_IMAGE }}#$CONJUR_AUTHENTICATOR_IMAGE#g" "./yaml/goapp.yml" |
    sed -e "s#{{ GOAPP_IMAGE }}#$GOAPP_IMAGE#g" |
    sed -e "s#{{ DEMOAPPS_NAMESPACE }}#$DEMOAPPS_NAMESPACE#g" |
    sed -e "s#{{ GOAPP_SERVICEACCOUNT }}#$GOAPP_SERVICEACCOUNT#g" |
    sed -e "s#{{ CONJUR_APPLIANCE_URL }}#$CONJUR_APPLIANCE_URL#g" |
    sed -e "s#{{ CONJUR_AUTHN_URL }}#$CONJUR_AUTHN_URL#g" |
    sed -e "s#{{ CONJUR_ACCOUNT }}#$CONJUR_ACCOUNT#g" |
    sed -e "s#{{ GOAPP_CONJUR_AUTHN_LOGIN }}#$GOAPP_CONJUR_AUTHN_LOGIN#g" |
    $cli apply -f -
}

main $@
