#!/bin/bash 
set -eo pipefail

. utils.sh


main() {
  
  deploy_secretless
  announce "Secretless deployed."
}

deploy_secretless() {
  $cli delete --ignore-not-found \
     deployment/secretless \
     configmap/secretless-config
  announce "Deploying Secretless."


  ensure_env_database

  case "${DEMOAPPS_DB}" in
  mssql)
    PORT=1433
    PROTOCOL=sqlserver
    secretless_db_url="$PROTOCOL://localhost:$PORT;databaseName=$DEMOAPPS_DB_NAME"
    ;;
  postgres)
    PORT=5432
    PROTOCOL=postgresql
    secretless_db_url="$PROTOCOL://localhost:$PORT/$DEMOAPPS_DB_NAME"
    ;;
  mysql)
    PORT=3306
    PROTOCOL=mysql
    secretless_db_url="$PROTOCOL://localhost:$PORT/$DEMOAPPS_DB_NAME"
    ;;
  esac


  sed -e "s#{{ SECRETLESS_BROKER_IMAGE }}#$SECRETLESS_BROKER_IMAGE#g" "./yaml/secretless.yml" |
    sed -e "s#{{ SECRETLESS_SERVICEACCOUNT }}#$SECRETLESS_SERVICEACCOUNT#g" |
    sed -e "s#{{ SECRETLESS_APP_IMAGE }}#$DEMOAPP_IMAGE#g" |
    sed -e "s#{{ SECRETLESS_DB_URL }}#$secretless_db_url#g" |
    sed -e "s#{{ DEMOAPPS_DB }}#$DEMOAPPS_DB#g" |
    sed -e "s#{{ DEMOAPPS_NAMESPACE }}#$DEMOAPPS_NAMESPACE#g" |
    sed -e "s#{{ CONJUR_APPLIANCE_URL }}#$CONJUR_APPLIANCE_URL#g" |
    sed -e "s#{{ CONJUR_AUTHN_URL }}#$CONJUR_AUTHN_URL#g" |
    sed -e "s#{{ CONJUR_ACCOUNT }}#$CONJUR_ACCOUNT#g" |
    sed -e "s#{{ SECRETLESS_CONJUR_AUTHN_LOGIN }}#$SECRETLESS_CONJUR_AUTHN_LOGIN#g" |
    sed -e "s#{{ CONJUR_SERVICEACCOUNT_NAME }}#$CONJUR_SERVICEACCOUNT_NAME#g" |
    $cli apply -f -
}

main $@
