#!/bin/bash 
set -eo pipefail

. utils.sh


main() {
  
  deploy_db_backend
  announce "Demo apps backend deployed."
}

deploy_db_backend() {
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

  ensure_env_database
  
  case "${DEMOAPPS_DB}" in
  mssql)
    echo "Deploying demo apps backend"

    sed -e "s#{{ DEMOAPPS_MSSQL_IMAGE }}#$DEMOAPPS_MSSQL_IMAGE#g" ./$PLATFORM/tmp.${DEMOAPPS_NAMESPACE}.mssql.yml |
      sed -e "s#{{ DEMOAPPS_NAMESPACE }}#$DEMOAPPS_NAMESPACE#g" |
      sed -e "s#{{ DEMOAPPS_DB_USER }}#$DEMOAPPS_DB_USER#g" |
      sed -e "s#{{ DEMOAPPS_DB_NAME }}#$DEMOAPPS_DB_NAME#g" |
      $cli create -f -
    ;;
  postgres)
    #echo "Create demoapps-db-certs secret for demo apps backend"
    #oc --namespace $DEMOAPPS_NAMESPACE \
      #create secret generic \
      #demoapps-db-certs \
      #--from-file=server.crt=../etc/ca.pem \
      #--from-file=server.key=../etc/ca-key.pem

    echo "Deploying demo apps backend"

    sed -e "s#{{ DEMOAPPS_PG_IMAGE }}#$DEMOAPPS_PG_IMAGE#g" ./$PLATFORM/tmp.${DEMOAPPS_NAMESPACE}.postgres.yml |
      sed -e "s#{{ DEMOAPPS_NAMESPACE }}#$DEMOAPPS_NAMESPACE#g" |
      sed -e "s#{{ DEMOAPPS_DB_USER }}#$DEMOAPPS_DB_USER#g" |
      sed -e "s#{{ DEMOAPPS_DB_NAME }}#$DEMOAPPS_DB_NAME#g" |
      $cli create -f -
    ;;
  mysql)
    echo "Deploying demo apps backend"
    
    sed -e "s#{{ DEMOAPPS_MYSQL_IMAGE }}#$DEMOAPPS_MYSQL_IMAGE#g" ./$PLATFORM/tmp.${DEMOAPPS_NAMESPACE}.mysql.yml |
      sed -e "s#{{ DEMOAPPS_NAMESPACE }}#$DEMOAPPS_NAMESPACE#g" |
      sed -e "s#{{ DEMOAPPS_DB_USER }}#$DEMOAPPS_DB_USER#g" |
      sed -e "s#{{ DEMOAPPS_DB_NAME }}#$DEMOAPPS_DB_NAME#g" |
      $cli create -f -
    ;;
  esac

}

main $@
