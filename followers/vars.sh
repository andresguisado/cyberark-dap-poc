#!/bin/bash
##########
# CONFIG #
##########
export PLATFORM=kubernetes
#export PLATFORM=openshift

#Follower 
export CONJUR_APPLIANCE_IMAGE=andresguisado/conjur-appliance:11.7.0
#export CONJUR_APPLIANCE_IMAGE=image-registry.openshift-image-registry.svc:5000/ag-cyberark/conjur-appliance:11.7.0
#export SEEDFETCHER_IMAGE=cyberark/dap-seedfetcher:latest
export SEEDFETCHER_IMAGE=image-registry.openshift-image-registry.svc:5000/ag-cyberark/dap-seedfetcher:latest
export CONJUR_NAMESPACE=cyberark
export CONJUR_SERVICEACCOUNT=dap-cluster
export CONJUR_FOLLOWER_COUNT=1

# Authenticator ID
export AUTHENTICATOR_ID=k8s-cluster1
#export AUTHENTICATOR_ID=okd4-cluster1

#Master
export CONJUR_APPLIANCE_URL=https://dap-master.plangiro.com
export CONJUR_ACCOUNT=cybr


#Conjur Master DNS configuration - If Kubernetes cluster is able to resolve CONJUR_APPLIANCE_URL, DNS=true
# If not, DNS=false and fill in CONJUR_MASTER_IP CONJUR_MASTER_SERVICE_NAME
export CONJUR_MASTER_DNS=true
export CONJUR_MASTER_IP=3.8.111.170
export CONJUR_MASTER_SERVICE_NAME=dap-master

# Seed-fetcher URL for Follower auto-bootstrapping
if [[ "${CONJUR_MASTER_DNS}" = "true" ]]; then
    export FOLLOWER_SEED=$CONJUR_APPLIANCE_URL/configuration/$CONJUR_ACCOUNT/seed/follower
else
    export FOLLOWER_SEED=$CONJUR_MASTER_SERVICE_NAME/configuration/$CONJUR_ACCOUNT/seed/follower
fi



