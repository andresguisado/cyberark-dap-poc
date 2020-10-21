#!/bin/bash 
set -eo pipefail

. utils.sh

main() {

  #create_namespace
  set_namespace $DEMOAPPS_NAMESPACE
  create_apps_service_accounts
  create_k8s_authenticator_role_binding
  create_k8s_provider_role_binding
  create_conjur_certificate_configmap
}


create_namespace() {

   announce "Creating Demoapps namespace."  
  
  if has_namespace "$DEMOAPPS_NAMESPACE"; then
    echo "Namespace '$DEMOAPPS_NAMESPACE' exists, not going to create it."
    set_namespace $DEMOAPPS_NAMESPACE
  else
    sed -e "s#{{ DEMOAPPS_NAMESPACE }}#$DEMOAPPS_NAMESPACE#g" ./$PLATFORM/demoapps-namespace.yml |
    $cli apply -f -
    set_namespace $DEMOAPPS_NAMESPACE
  fi
}

create_apps_service_accounts() {
  announce "Creating applications service accounts."

  local SERVICEACCOUNTS=($API_SUMMON_APP_SERVICEACCOUNT $SECRETLESS_SERVICEACCOUNT $GOAPP_SERVICEACCOUNT $JAVA_INIT_SERVICEACCOUNT $JAVA_SIDECAR_SERVICEACCOUNT $K8S_PROVIDER_SERVICEACCOUNT)

    for serviceaccounts in "${SERVICEACCOUNTS[@]}"
    do
      sed -e "s#{{ DEMOAPPS_NAMESPACE }}#$DEMOAPPS_NAMESPACE#g" "./$PLATFORM/apps-service-account.yml" |
      sed -e "s#{{ SERVICEACCOUNT_NAME }}#$serviceaccounts#g" |
      $cli apply -f -
    done
  announce "Apps Service accounts created" 
}


create_k8s_authenticator_role_binding() {
  announce "Creating k8s authenticator role binding."  

  sed -e "s#{{ DEMOAPPS_NAMESPACE }}#$DEMOAPPS_NAMESPACE#g" "./$PLATFORM/k8s-authenticator-role-binding.yml" |
  sed -e "s#{{ CONJUR_SERVICEACCOUNT }}#$CONJUR_SERVICEACCOUNT#g" |
  sed -e "s#{{ CONJUR_NAMESPACE }}#$CONJUR_NAMESPACE#g" |
  $cli apply -f -

  announce "k8s authenticator role binding created"  
}

create_k8s_provider_role_binding() {
  announce "Creating k8s provider role binding."  

  sed -e "s#{{ DEMOAPPS_NAMESPACE }}#$DEMOAPPS_NAMESPACE#g" "./$PLATFORM/k8s-provider-role-binding.yml" |
  sed -e "s#{{ K8S_PROVIDER_SERVICEACCOUNT }}#$K8S_PROVIDER_SERVICEACCOUNT#g" |
  $cli apply -f -

  announce "k8s provider role binding created."  
}

create_conjur_certificate_configmap() {
  SERVER_CERTIFICATE="./server_certificate.cert"
  ./_save_server_cert.sh $SERVER_CERTIFICATE
  echo "Deleting configmap"
  $cli delete --ignore-not-found configmap -n $DEMOAPPS_NAMESPACE dap-certificate
  if [[ -f "${SERVER_CERTIFICATE}" ]]; then
    announce "Saving Conjur certificate to configmap."
    $cli create configmap dap-certificate --from-file=ssl-certificate=<(cat "${SERVER_CERTIFICATE}")
  else
    echo "WARN: no Conjur certificate was provided saving empty configmap"
    $cli create configmap dap-certificate --from-file=ssl-certificate=<(echo "")
  fi
  
  rm $SERVER_CERTIFICATE
} 

create_conjur_certificate_configmap2() {
  announce "Storing Conjur cert for test app configuration."

  $cli project $CONJUR_NAMESPACE

  echo "Retrieving Conjur certificate."

  if $cli get pods --selector role=follower --no-headers; then
    follower_pod_name=$($cli get pods --selector role=follower -n $CONJUR_NAMESPACE --no-headers | awk '{ print $1 }' | head -1)
    ssl_cert=$($cli exec $follower_pod_name -n $CONJUR_NAMESPACE -- cat /opt/conjur/etc/ssl/conjur.pem)
  else
    echo "Regular follower not found. Trying to assume a decomposed follower..."
    follower_pod_name=$($cli get pods --selector role=decomposed-follower -n $CONJUR_NAMESPACE --no-headers | awk '{ print $1 }' | head -1)
    ssl_cert=$($cli exec -c "nginx" $follower_pod_name -n $CONJUR_NAMESPACE -- cat /opt/conjur/etc/ssl/cert/tls.crt)
  fi

  $cli project $DEMOAPPS_NAMESPACE

  $cli delete configmap --ignore-not-found=true dap-certificate -n $DEMOAPPS_NAMESPACE

  # Store the Conjur cert in a ConfigMap.
  $cli create configmap dap-certificate -n $DEMOAPPS_NAMESPACE --from-file=ssl-certificate=<(echo "$ssl_cert")

  echo "Conjur cert stored as configmap."

}



main $@