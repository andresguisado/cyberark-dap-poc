#! /bin/bash

. utils.sh

read -p "Please provide your Conjur login: " CONJUR_LOGIN
read -s -p "Please provide your Conjur password: " CONJUR_PASSWORD; echo


ensure_env_database
case "${DEMOAPPS_DB}" in
mssql)
  PORT=1433
  PROTOCOL=sqlserver
  java_init_db_url="$PROTOCOL://java-init-db.$DEMOAPPS_NAMESPACE:$PORT;databaseName=$DEMOAPPS_DB_NAME"
  java_sidecar_db_url="$PROTOCOL://java-sidecar-db.$DEMOAPPS_NAMESPACE:$PORT;databaseName=$DEMOAPPS_DB_NAME"
  k8s_provider_db_url="$PROTOCOL://k8s-provider-db.$DEMOAPPS_NAMESPACE:$PORT;databaseName=$DEMOAPPS_DB_NAME"
  secretless_host="secretless-db.$DEMOAPPS_NAMESPACE"
  secretless_port=$PORT
  ;;
postgres)
  PORT=5432
  PROTOCOL=postgresql
  java_init_db_url="$PROTOCOL://java-init-db.$DEMOAPPS_NAMESPACE:$PORT/$DEMOAPPS_DB_NAME"
  java_sidecar_db_url="$PROTOCOL://java-sidecar-db.$DEMOAPPS_NAMESPACE:$PORT/$DEMOAPPS_DB_NAME"
  k8s_provider_db_url="$PROTOCOL://k8s-provider-db.$DEMOAPPS_NAMESPACE:$PORT/$DEMOAPPS_DB_NAME"
  secretless_host="secretless-db.$DEMOAPPS_NAMESPACE"
  secretless_port=$PORT
  ;;
mysql)
  PORT=3306
  PROTOCOL=mysql
  java_init_db_url="$PROTOCOL://java-sidecar-db.$DEMOAPPS_NAMESPACE:$PORT/$DEMOAPPS_DB_NAME"
  java_sidecar_db_url="$PROTOCOL://java-sidecar-db.$DEMOAPPS_NAMESPACE:$PORT/$DEMOAPPS_DB_NAME"
  k8s_provider_db_url="$PROTOCOL://k8s-provider-db.$DEMOAPPS_NAMESPACE:$PORT/$DEMOAPPS_DB_NAME"
  secretless_host="secretless-db.$DEMOAPPS_NAMESPACE"
  secretless_port=$PORT
  ;;
esac


password=$(openssl rand -base64 29 | tr -d "=+/" | cut -c1-25)

api_key=$(curl -s -k \
		--user $CONJUR_LOGIN:$CONJUR_PASSWORD \
		$CONJUR_MASTER_FQDN/authn/$CONJUR_ACCOUNT/login)

response=$( curl -s -k \
		-X POST \
		-d $api_key \
		-H "Content-Type: text/plain" \
		$CONJUR_MASTER_FQDN/authn/$CONJUR_ACCOUNT/admin/authenticate)

token=$(echo -n $response | base64 | tr -d '\r\n')
curl -k  \
     -H "Authorization: Token token=\"$token\"" \
     --data "$DEMOAPPS_DB_USER" \
      $CONJUR_MASTER_FQDN/secrets/$CONJUR_ACCOUNT/variable/dev/$AUTHENTICATOR_ID/$JAVA_INIT_CONJUR_POLICY_NAME/username
curl -k  \
     -H "Authorization: Token token=\"$token\"" \
     --data "$DEMOAPPS_DB_USER" \
      $CONJUR_MASTER_FQDN/secrets/$CONJUR_ACCOUNT/variable/dev/$AUTHENTICATOR_ID/$JAVA_SIDECAR_CONJUR_POLICY_NAME/username
curl -k  \
     -H "Authorization: Token token=\"$token\"" \
     --data "$DEMOAPPS_DB_USER" \
      $CONJUR_MASTER_FQDN/secrets/$CONJUR_ACCOUNT/variable/dev/$AUTHENTICATOR_ID/$SECRETLESS_CONJUR_POLICY_NAME/username
curl -k  \
     -H "Authorization: Token token=\"$token\"" \
     --data "$DEMOAPPS_DB_USER" \
      $CONJUR_MASTER_FQDN/secrets/$CONJUR_ACCOUNT/variable/dev/$AUTHENTICATOR_ID/$K8S_PROVIDER_CONJUR_POLICY_NAME/username
curl -k  \
     -H "Authorization: Token token=\"$token\"" \
     --data "$DEMOAPPS_DB_USER" \
      $CONJUR_MASTER_FQDN/secrets/$CONJUR_ACCOUNT/variable/dev/$AUTHENTICATOR_ID/$GOAPP_CONJUR_POLICY_NAME/goapp_user

curl -k  \
     -H "Authorization: Token token=\"$token\"" \
     --data "$password" \
      $CONJUR_MASTER_FQDN/secrets/$CONJUR_ACCOUNT/variable/dev/$AUTHENTICATOR_ID/$JAVA_INIT_CONJUR_POLICY_NAME/password
curl -k  \
     -H "Authorization: Token token=\"$token\"" \
     --data "$password" \
      $CONJUR_MASTER_FQDN/secrets/$CONJUR_ACCOUNT/variable/dev/$AUTHENTICATOR_ID/$JAVA_SIDECAR_CONJUR_POLICY_NAME/password
curl -k  \
     -H "Authorization: Token token=\"$token\"" \
     --data "$password" \
      $CONJUR_MASTER_FQDN/secrets/$CONJUR_ACCOUNT/variable/dev/$AUTHENTICATOR_ID/$SECRETLESS_CONJUR_POLICY_NAME/password
curl -k  \
     -H "Authorization: Token token=\"$token\"" \
     --data "$password" \
      $CONJUR_MASTER_FQDN/secrets/$CONJUR_ACCOUNT/variable/dev/$AUTHENTICATOR_ID/$K8S_PROVIDER_CONJUR_POLICY_NAME/password
curl -k  \
     -H "Authorization: Token token=\"$token\"" \
     --data "$password" \
      $CONJUR_MASTER_FQDN/secrets/$CONJUR_ACCOUNT/variable/dev/$AUTHENTICATOR_ID/$GOAPP_CONJUR_POLICY_NAME/goapp_pwd

curl -k  \
     -H "Authorization: Token token=\"$token\"" \
     --data "$java_init_db_url" \
      $CONJUR_MASTER_FQDN/secrets/$CONJUR_ACCOUNT/variable/dev/$AUTHENTICATOR_ID/$JAVA_INIT_CONJUR_POLICY_NAME/url
curl -k  \
     -H "Authorization: Token token=\"$token\"" \
     --data "$java_sidecar_db_url" \
      $CONJUR_MASTER_FQDN/secrets/$CONJUR_ACCOUNT/variable/dev/$AUTHENTICATOR_ID/$JAVA_SIDECAR_CONJUR_POLICY_NAME/url
curl -k  \
     -H "Authorization: Token token=\"$token\"" \
     --data "$secretless_host" \
      $CONJUR_MASTER_FQDN/secrets/$CONJUR_ACCOUNT/variable/dev/$AUTHENTICATOR_ID/$SECRETLESS_CONJUR_POLICY_NAME/host
curl -k  \
     -H "Authorization: Token token=\"$token\"" \
     --data "$secretless_port" \
      $CONJUR_MASTER_FQDN/secrets/$CONJUR_ACCOUNT/variable/dev/$AUTHENTICATOR_ID/$SECRETLESS_CONJUR_POLICY_NAME/port
curl -k  \
     -H "Authorization: Token token=\"$token\"" \
     --data "$k8s_provider_db_url" \
      $CONJUR_MASTER_FQDN/secrets/$CONJUR_ACCOUNT/variable/dev/$AUTHENTICATOR_ID/$K8S_PROVIDER_CONJUR_POLICY_NAME/url

pushd yaml > /dev/null 2>&1
  sed "s#{{ DEMOAPPS_DB_PASSWORD }}#$password#g" ./mssql.template.yml > ./tmp.${DEMOAPPS_NAMESPACE}.mssql.yml 
  sed "s#{{ DEMOAPPS_DB_PASSWORD }}#$password#g" ./mysql.template.yml > ./tmp.${DEMOAPPS_NAMESPACE}.mysql.yml 
  sed "s#{{ DEMOAPPS_DB_PASSWORD }}#$password#g" ./postgres.template.yml > ./tmp.${DEMOAPPS_NAMESPACE}.postgres.yml 
popd > /dev/null 2>&1

echo "Secrets for DB Backend populated."