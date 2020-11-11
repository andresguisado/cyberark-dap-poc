#!/bin/bash 
set -eo pipefail

. utils.sh


main() {
  
  deploy_java_init_app
  deploy_java_sidecar_app
  announce "JAVA apps deployed."
}


deploy_java_init_app() {

     if [[ $PLATFORM == openshift ]]; then
       $cli delete --ignore-not-found \
          deployment/java-init-app \
          service/java-init-app \
          route/java-init-app
     else
       $cli delete --ignore-not-found \
          deployment/java-init-app \
          service/java-init-app 
     fi  

  announce "Deploying JAVA Init APP."

  sed -e "s#{{ CONJUR_AUTHENTICATOR_IMAGE }}#$CONJUR_AUTHENTICATOR_IMAGE#g" "./yaml/java-init-app.yml" |
    sed -e "s#{{ JAVA_INIT_APP_IMAGE }}#$JAVA_INIT_IMAGE#g" |
    sed -e "s#{{ DEMOAPPS_NAMESPACE }}#$DEMOAPPS_NAMESPACE#g" |
    sed -e "s#{{ JAVA_INIT_SERVICEACCOUNT }}#$JAVA_INIT_SERVICEACCOUNT#g" |
    sed -e "s#{{ DB_PLATFORM }}#$DEMOAPPS_DB#g" |
    sed -e "s#{{ CONJUR_APPLIANCE_URL }}#$CONJUR_APPLIANCE_URL#g" |
    sed -e "s#{{ CONJUR_AUTHN_URL }}#$CONJUR_AUTHN_URL#g" |
    sed -e "s#{{ CONJUR_ACCOUNT }}#$CONJUR_ACCOUNT#g" |
    sed -e "s#{{ JAVA_INIT_CONJUR_AUTHN_LOGIN }}#$JAVA_INIT_CONJUR_AUTHN_LOGIN#g" |
    $cli apply -f -

    if [[ $PLATFORM == openshift ]]; then
      $cli expose service java-init-app
    fi 
    
}

deploy_java_sidecar_app() {

     if [[ $PLATFORM == openshift ]]; then
       $cli delete --ignore-not-found \
          deployment/java-sidecar-app \
          service/java-sidecar-app \
          route/java-init-app
     else
       $cli delete --ignore-not-found \
          deployment/java-sidecar-app \
          service/java-sidecar-app 
     fi 


  announce "Deploying JAVA Sidecar APP."
  
  sed -e "s#{{ CONJUR_AUTHENTICATOR_IMAGE }}#$CONJUR_AUTHENTICATOR_IMAGE#g" "./$yaml/java-sidecar-app.yml" |
    sed -e "s#{{ JAVA_SIDECAR_APP_IMAGE }}#$JAVA_SIDECAR_IMAGE#g" |
    sed -e "s#{{ DEMOAPPS_NAMESPACE }}#$DEMOAPPS_NAMESPACE#g" |
    sed -e "s#{{ JAVA_SIDECAR_SERVICEACCOUNT }}#$JAVA_SIDECAR_SERVICEACCOUNT#g" |
    sed -e "s#{{ DB_PLATFORM }}#$DEMOAPPS_DB#g" |
    sed -e "s#{{ CONJUR_APPLIANCE_URL }}#$CONJUR_APPLIANCE_URL#g" |
    sed -e "s#{{ CONJUR_AUTHN_URL }}#$CONJUR_AUTHN_URL#g" |
    sed -e "s#{{ CONJUR_ACCOUNT }}#$CONJUR_ACCOUNT#g" |
    sed -e "s#{{ JAVA_SIDECAR_CONJUR_AUTHN_LOGIN }}#$JAVA_SIDECAR_CONJUR_AUTHN_LOGIN#g" |
    $cli apply -f -

    if [[ $PLATFORM == openshift ]]; then
      $cli expose service java-sidecar-app
    fi 
    
}

main $@
