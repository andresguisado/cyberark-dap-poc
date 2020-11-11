#!/bin/bash 
set -eo pipefail

. utils.sh

main() {
  
  set_namespace $CONJUR_NAMESPACE
  add_server_certificate_to_configmap
  deploy_conjur_followers
  add_dap_kubernetes_values
  initialize_ca
  add_new_authenticator
  restart_followers
  sleep 10
  announce "Followers deployed."

}

add_server_certificate_to_configmap() {
  SERVER_CERTIFICATE="./server_certificate.cert"
  ./_save_server_cert.sh $SERVER_CERTIFICATE
  if [[ -f "${SERVER_CERTIFICATE}" ]]; then
    announce "Saving server certificate to configmap."
    $cli create configmap dap-certificate --from-file=ssl-certificate=<(cat "${SERVER_CERTIFICATE}")
  else
    echo "WARN: no server certificate was provided saving empty configmap"
    $cli create configmap dap-certificate --from-file=ssl-certificate=<(echo "")
  fi
  
  rm $SERVER_CERTIFICATE
}

deploy_conjur_followers() {
  announce "Deploying Conjur Follower pods."

  conjur_appliance_image=$CONJUR_APPLIANCE_IMAGE
  seedfetcher_image=$SEEDFETCHER_IMAGE
  conjur_authn_login_prefix=host/conjur/authn-k8s/$AUTHENTICATOR_ID/followers


  sed -e "s#{{ CONJUR_APPLIANCE_IMAGE }}#$conjur_appliance_image#g" "./yaml/conjur-follower.yml" |
    sed -e "s#{{ AUTHENTICATOR_ID }}#$AUTHENTICATOR_ID#g" |
    sed -e "s#{{ IMAGE_PULL_POLICY }}#$IMAGE_PULL_POLICY#g" |
    sed -e "s#{{ CONJUR_FOLLOWER_COUNT }}#${CONJUR_FOLLOWER_COUNT:-1}#g" |
    sed -e "s#{{ CONJUR_SEED_FILE_URL }}#$FOLLOWER_SEED#g" |
    sed -e "s#{{ CONJUR_SEED_FETCHER_IMAGE }}#$seedfetcher_image#g" |
    sed -e "s#{{ CONJUR_ACCOUNT }}#$CONJUR_ACCOUNT#g" |
    sed -e "s#{{ CONJUR_AUTHN_LOGIN_PREFIX }}#$conjur_authn_login_prefix#g" |
    sed -e "s#{{ CONJUR_SERVICEACCOUNT }}#$CONJUR_SERVICEACCOUNT#g" |
    $cli apply -f -
}

add_dap_kubernetes_values() {
  announce "Adding value to kubernetes conjur variables"

  #retrieve the name of the secret that stores the service account token
  TOKEN_SECRET_NAME="$($cli get secrets -n $CONJUR_NAMESPACE | grep 'dap.*service-account-token' | head -n1 | awk '{print $1}')"

  #update DAP with the certificate of the namespace service account
  docker exec dap-cli conjur variable values add conjur/authn-k8s/$AUTHENTICATOR_ID/kubernetes/ca-cert \
    "$($cli get secret -n $CONJUR_NAMESPACE $TOKEN_SECRET_NAME -o json | jq -r '.data["ca.crt"]' | base64 --decode)"

  #update DAP with the namespace service account token
  docker exec dap-cli conjur variable values add conjur/authn-k8s/$AUTHENTICATOR_ID/kubernetes/service-account-token \
    "$($cli get secret -n $CONJUR_NAMESPACE $TOKEN_SECRET_NAME -o json | jq -r .data.token | base64 --decode)"

  #update DAP with the URL of the Kubernetes API
  docker exec dap-cli conjur variable values add conjur/authn-k8s/$AUTHENTICATOR_ID/kubernetes/api-url \
    "$($cli config view --minify -o json | jq -r '.clusters[0].cluster.server')"

}

initialize_ca() {
    announce "Initializing CA in Conjur Master..."
    docker exec dap-master \
      chpst -u conjur conjur-plugin-service possum \
        rake authn_k8s:ca_init["conjur/authn-k8s/$AUTHENTICATOR_ID"]
    announce "CA initialized."
}

add_new_authenticator() {

  announce "Updating list of whitelisted authenticators..."
  
  set +e
  CURRENT_AUTHENTICATORS=$(docker exec dap-master bash -c "evoke variable list CONJUR_AUTHENTICATORS | head -n 1")
  set -e

  AUTHENTICATOR_ID=authn-k8s/$AUTHENTICATOR_ID

  #if [[ "$CURRENT_AUTHENTICATORS" == "" ]]; then	# If no authenticators specified...
  #  docker exec -i dap-master evoke variable set CONJUR_AUTHENTICATORS $AUTHENTICATOR_ID
  #else
		docker exec -i dap-master evoke variable set CONJUR_AUTHENTICATORS $CURRENT_AUTHENTICATORS,$AUTHENTICATOR_ID
  #fi
 
  announce "Authenticators updated."
}

restart_followers() {

  announce "Restarting followers to get them restarted with the right values"
  #delete the pods in the DAP namespace so that they can restart with the appropriate values
  $cli delete pods -n $CONJUR_NAMESPACE --all 
  
}


main $@
