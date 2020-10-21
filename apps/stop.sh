#!/bin/bash
set -euo pipefail

. utils.sh

     
echo "Deleting goapp and goapp-epv deployment"
$cli delete --ignore-not-found \
     -n $DEMOAPPS_NAMESPACE deployment/goapp \
     -n $DEMOAPPS_NAMESPACE deployment/goapp-epv \
     -n $DEMOAPPS_NAMESPACE sa/goapp-account 

echo "Deleting java-init-app deployment"
$cli delete --ignore-not-found \
     -n $DEMOAPPS_NAMESPACE deployment/java-init-app \
     -n $DEMOAPPS_NAMESPACE service/java-init-app \
     -n $DEMOAPPS_NAMESPACE sa/java-init-app-account

echo "Deleting java-sidecar-app deployment"
$cli delete --ignore-not-found \
     -n $DEMOAPPS_NAMESPACE deployment/java-sidecar-app \
     -n $DEMOAPPS_NAMESPACE service/java-sidecar-app \
     -n $DEMOAPPS_NAMESPACE sa/java-sidecar-app-account

echo "Deleting k8s-provider-app deployment"
$cli delete --ignore-not-found \
     -n $DEMOAPPS_NAMESPACE deployment/k8s-provider-app \
     -n $DEMOAPPS_NAMESPACE secret/db-credentials \
     -n $DEMOAPPS_NAMESPACE sa/k8s-provider-app-account


echo "Deleting secretless-app deployment"
$cli delete --ignore-not-found \
     -n $DEMOAPPS_NAMESPACE deployment/secretless \
     -n $DEMOAPPS_NAMESPACE configmap/secretless-config \
     -n $DEMOAPPS_NAMESPACE sa/secretless-account


ensure_env_database

case "${DEMOAPPS_DB}" in
mssql)
  echo "Backend - Deleting deployment and service "
  $cli delete --ignore-not-found statefulsets -n $DEMOAPPS_NAMESPACE java-init-mssql
  $cli delete --ignore-not-found statefulsets -n $DEMOAPPS_NAMESPACE java-sidecar-mssql
  $cli delete --ignore-not-found statefulsets -n $DEMOAPPS_NAMESPACE secretless-db-mssql
  $cli delete --ignore-not-found statefulsets -n $DEMOAPPS_NAMESPACE k8s-provider-db-mssql

  $cli delete --ignore-not-found svc -n $DEMOAPPS_NAMESPACE java-init-db
  $cli delete --ignore-not-found svc -n $DEMOAPPS_NAMESPACE java-sidecar-db
  $cli delete --ignore-not-found svc -n $DEMOAPPS_NAMESPACE secretless-db
  $cli delete --ignore-not-found svc -n $DEMOAPPS_NAMESPACE k8s-provider-db
  ;;
postgres)
  echo "Backend - Deleting deployment and service "
  $cli delete --ignore-not-found statefulsets -n $DEMOAPPS_NAMESPACE java-init-pg
  $cli delete --ignore-not-found statefulsets -n $DEMOAPPS_NAMESPACE java-sidecar-pg
  $cli delete --ignore-not-found statefulsets -n $DEMOAPPS_NAMESPACE secretless-db-pg
  $cli delete --ignore-not-found statefulsets -n $DEMOAPPS_NAMESPACE k8s-provider-db-pg

  $cli delete --ignore-not-found svc -n $DEMOAPPS_NAMESPACE java-init-db
  $cli delete --ignore-not-found svc -n $DEMOAPPS_NAMESPACE java-sidecar-db
  $cli delete --ignore-not-found svc -n $DEMOAPPS_NAMESPACE secretless-db
  $cli delete --ignore-not-found svc -n $DEMOAPPS_NAMESPACE k8s-provider-db
  ;;
mysql)
  echo "Backend - Deleting deployment and service"
  $cli delete --ignore-not-found statefulsets -n $DEMOAPPS_NAMESPACE java-init-mysql
  $cli delete --ignore-not-found statefulsets -n $DEMOAPPS_NAMESPACE java-sidecar-mysql
  $cli delete --ignore-not-found statefulsets -n $DEMOAPPS_NAMESPACE secretless-db-mysql
  $cli delete --ignore-not-found statefulsets -n $DEMOAPPS_NAMESPACE k8s-provider-db-mysql

  $cli delete --ignore-not-found svc -n $DEMOAPPS_NAMESPACE java-init-db
  $cli delete --ignore-not-found svc -n $DEMOAPPS_NAMESPACE java-sidecar-db
  $cli delete --ignore-not-found svc -n $DEMOAPPS_NAMESPACE secretless-db
  $cli delete --ignore-not-found svc -n $DEMOAPPS_NAMESPACE k8s-provider-db
  ;;
esac


echo "Deleting k8s-authenticator role and rolebinding deployment"
$cli delete --ignore-not-found \
     -n $DEMOAPPS_NAMESPACE rolebinding/dap-authenticator-role-binding-$DEMOAPPS_NAMESPACE \
     -n $DEMOAPPS_NAMESPACE role/dap-authenticator-$CONJUR_NAMESPACE

echo "Deleting k8s-providerrole and rolebinding deployment"
$cli delete --ignore-not-found \
     -n $DEMOAPPS_NAMESPACE rolebinding/k8s-provider-role-binding-$DEMOAPPS_NAMESPACE \
     -n $DEMOAPPS_NAMESPACE role/k8s-provider-$DEMOAPPS_NAMESPACE

echo "Deleting DAP certificate"
$cli delete --ignore-not-found \
     -n $DEMOAPPS_NAMESPACE configmap/dap-certificate \



echo "Demoapps environment purged."