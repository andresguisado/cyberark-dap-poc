#!/bin/bash 
set -euo pipefail

. `dirname "$0"`/vars.sh
. utils.sh

main() {

  prepare_java_app_images
  announce "JAVA images pushed."

}

prepare_java_app_images(){

readonly APPS=(
  "init"
  "sidecar"
)

  announce "Building, tagging and pushing JAVA images."
  sudo docker build --no-cache -t java-app-builder -f ../build/javapp/Dockerfile.builder ../build/javapp/

  # retrieve the summon binaries
  id=$(sudo docker create java-app-builder)
  sudo docker cp $id:/usr/local/lib/summon/summon-conjur ../build/javapp/tmp.summon-conjur
  sudo docker cp $id:/usr/local/bin/summon ../build/javapp/tmp.summon
  sudo docker rm --volumes $id


  for app_type in "${APPS[@]}"; do
    # prep secrets.yml
    # NOTE: generated files are prefixed with the test app namespace to allow for parallel CI
    sed -e "s#{{ JAVA_APP_NAME }}#java-$app_type-db#g" "../build/javapp/secrets.template.yml" |
    sed -e "s#{{ AUTHENTICATOR_ID }}#$AUTHENTICATOR_ID#g" > "../build/javapp/tmp.$DEMOAPPS_NAMESPACE.secrets.yml"

    echo "Building test app image"
    sudo docker build --no-cache \
      --build-arg namespace=$DEMOAPPS_NAMESPACE \
      --tag test-app:$DEMOAPPS_NAMESPACE \
      --file ../build/javapp/Dockerfile ../build/javapp

    sudo docker tag test-app:$DEMOAPPS_NAMESPACE $DOCKER_REGISTRY_PATH/$DEMOAPPS_NAMESPACE/java-$app_type-app:$DEMOAPPS_NAMESPACE

    sudo docker push  $DOCKER_REGISTRY_PATH/$DEMOAPPS_NAMESPACE/java-$app_type-app:$DEMOAPPS_NAMESPACE

  done

}