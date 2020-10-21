#!/bin/bash
set -euo pipefail

. utils.sh

main() {

  #create_namespace
  set_namespace $CONJUR_NAMESPACE
  create_service_account
  create_cluster_role
  #configure_oc_rbac
  announce "Conjur namespace ready."

}

create_namespace() {
  announce "Creating Conjur namespace."  
  
  if has_namespace "$CONJUR_NAMESPACE"; then
    echo "Namespace '$CONJUR_NAMESPACE' exists, not going to create it."
    set_namespace $CONJUR_NAMESPACE
  else
    sed -e "s#{{ CONJUR_NAMESPACE }}#$CONJUR_NAMESPACE#g" ./yaml/conjur-namespace.yml |
    $cli apply -f -
    set_namespace $CONJUR_NAMESPACE
  fi
}

create_service_account() {
  announce "Creating dap service account."
  readonly CONJUR_SERVICEACCOUNT=${CONJUR_SERVICEACCOUNT}

  if has_serviceaccount $CONJUR_SERVICEACCOUNT; then
    echo "Service account '$CONJUR_SERVICEACCOUNT' exists, not going to create it."
  else
    sed -e "s#{{ CONJUR_NAMESPACE }}#$CONJUR_NAMESPACE#g" "./yaml/conjur-service-account.yml" |
    sed -e "s#{{ CONJUR_SERVICEACCOUNT }}#$CONJUR_SERVICEACCOUNT#g" |
    $cli apply -f -
  fi
}

create_cluster_role() {

  announce "Creating dap authenticator role and role-binding."
  $cli delete --ignore-not-found role dap-authenticator-$CONJUR_NAMESPACE

  sed -e "s#{{ CONJUR_NAMESPACE }}#$CONJUR_NAMESPACE#g" "./yaml/conjur-authenticator-role.yml" |
  sed -e "s#{{ CONJUR_SERVICEACCOUNT }}#$CONJUR_SERVICEACCOUNT#g" |
  $cli apply -f -
}


configure_oc_rbac() {

  announce "Configuring OpenShift admin permissions."
  # allow pods with conjur-cluster serviceaccount to run as root
  oc adm policy add-scc-to-user anyuid "system:serviceaccount:$CONJUR_NAMESPACE:$CONJUR_SERVICEACCOUNT"

  # add permissions for Conjur admin user on registry, default & Conjur cluster namespaces
  #oc adm policy add-role-to-user system:registry $OSHIFT_CONJUR_ADMIN_USERNAME
  #oc adm policy add-role-to-user system:image-builder $OSHIFT_CONJUR_ADMIN_USERNAME
  #oc adm policy add-role-to-user admin $OSHIFT_CONJUR_ADMIN_USERNAME -n default
  #oc adm policy add-role-to-user admin $OSHIFT_CONJUR_ADMIN_USERNAME -n $CONJUR_NAMESPACE
  
}


main $@
