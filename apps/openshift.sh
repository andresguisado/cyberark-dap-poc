#!/bin/bash

##########
# Config #
##########

export PLATFORM=openshift

#####################
# K8s Authenticator #
#####################
# Conjur Kubernetes Authenticator ID
export AUTHENTICATOR_ID=okd4-cluster1

###Conjur/DAP Kubernetes Authenticator
export CONJUR_AUTHENTICATOR_IMAGE=image-registry.openshift-image-registry.svc:5000/ag-demoapps/conjur-kubernetes-authenticator:latest

###Conjur/DAP Kubernetes Provider Authenticator
export CONJUR_K8S_PROVIDER_IMAGE=image-registry.openshift-image-registry.svc:5000/ag-demoapps/secrets-provider-for-k8s:latest

##Conjur/DAP Secretless Broker
export SECRETLESS_BROKER_IMAGE=image-registry.openshift-image-registry.svc:5000/ag-demoapps/secretless-broker:latest

# Conjur/DAP Follower Details
export CONJUR_SERVICE=dap-follower
export CONJUR_NAMESPACE=cyberark-xqcb-syst
export CONJUR_SERVICEACCOUNT=dap-cluster
export CONJUR_APPLIANCE_URL=https://$CONJUR_SERVICE.$CONJUR_NAMESPACE.svc.cluster.local/api
export CONJUR_AUTHN_URL=https://$CONJUR_SERVICE.$CONJUR_NAMESPACE.svc.cluster.local/api/authn-k8s/$AUTHENTICATOR_ID
export CONJUR_ACCOUNT=cybr


# Master FQDN
export CONJUR_MASTER_FQDN=https://dap-master2.cyberarkdemo.net


############
#  APPS    #
############

# DEMOAPPS NAMESPACE
export DEMOAPPS_NAMESPACE=demoapps-xqcb-syst

###CyberArk DEMOAPP (https://hub.docker.com/r/cyberark/demo-app - SpringBoot demo application)
export DEMOAPP_IMAGE=image-registry.openshift-image-registry.svc:5000/ag-demoapps/demo-app:latest

###GO APP
export GOAPP_IMAGE=image-registry.openshift-image-registry.svc:5000/ag-demoapps/goapp:latest
export GOAPP_CONJUR_POLICY_NAME=goapp
export GOAPP_SERVICEACCOUNT=go-app-account
export GOAPP_CONJUR_AUTHN_LOGIN=host/dev/$AUTHENTICATOR_ID/$GOAPP_CONJUR_POLICY_NAME/$GOAPP_SERVICEACCOUNT

## JAVA-INIT
export JAVA_INIT_IMAGE=image-registry.openshift-image-registry.svc:5000/ag-demoapps/java-init-app-okd4-cluster1:latest
export JAVA_INIT_CONJUR_POLICY_NAME=java-init-db
export JAVA_INIT_SERVICEACCOUNT=java-init-app-account
export JAVA_INIT_CONJUR_AUTHN_LOGIN=host/dev/$AUTHENTICATOR_ID/$JAVA_INIT_CONJUR_POLICY_NAME/$JAVA_INIT_SERVICEACCOUNT

## JAVA-SIDECAR
export JAVA_SIDECAR_IMAGE=image-registry.openshift-image-registry.svc:5000/ag-demoapps/java-sidecar-app-okd4-cluster1:latest
export JAVA_SIDECAR_CONJUR_POLICY_NAME=java-sidecar-db
export JAVA_SIDECAR_SERVICEACCOUNT=java-sidecar-app-account
export JAVA_SIDECAR_CONJUR_AUTHN_LOGIN=host/dev/$AUTHENTICATOR_ID/$JAVA_SIDECAR_CONJUR_POLICY_NAME/$JAVA_SIDECAR_SERVICEACCOUNT

###Secretless APP
export SECRETLESS_SERVICEACCOUNT=secretless-account
export SECRETLESS_CONJUR_POLICY_NAME=secretless-db
export SECRETLESS_CONJUR_AUTHN_LOGIN=host/dev/$AUTHENTICATOR_ID/$SECRETLESS_CONJUR_POLICY_NAME/$SECRETLESS_SERVICEACCOUNT

###K8S-PROVIDER-APP
export K8S_PROVIDER_SERVICEACCOUNT=k8s-provider-account
export K8S_PROVIDER_CONJUR_POLICY_NAME=k8s-provider-db
export K8S_PROVIDER_CONJUR_AUTHN_LOGIN=host/dev/$AUTHENTICATOR_ID/$K8S_PROVIDER_CONJUR_POLICY_NAME/$K8S_PROVIDER_SERVICEACCOUNT

###GO-EPV APP
# It will use the same $GOAPP_IMAGE and $GOAPP_SERVICEACCOUNT than GO APP
export GOAPP_EPV_CONJUR_POLICY_NAME=goapp-epv
export GOAPP_EPV_CONJUR_AUTHN_LOGIN=host/dev/$AUTHENTICATOR_ID/$GOAPP_EPV_CONJUR_POLICY_NAME/$GOAPP_SERVICEACCOUNT

############
#   DB     #
############

### [mssql, mysql or postgres]
export DEMOAPPS_DB=mssql

export DEMOAPPS_DB_NAME=demoapp
export DEMOAPPS_DB_USER=demoapp

###MYSQL
export DEMOAPPS_MYSQL_IMAGE=image-registry.openshift-image-registry.svc:5000/ag-demoapps/mysql-57-centos7
###POSTGRESQL
export DEMOAPPS_PG_IMAGE=image-registry.openshift-image-registry.svc:5000/ag-demoapps/postgresql-95-centos7
#MSSQL
export DEMOAPPS_MSSQL_IMAGE=image-registry.openshift-image-registry.svc:5000/ag-demoapps/mssql:latest