#!/bin/bash
set -euo pipefail

. utils.sh

#./stop.sh

./1_prepare_demoapps_environment.sh
./2_set_db_backend_pwd.sh
./3_deploy_db_backend.sh
./4_deploy_goapp.sh
./5_deploy_java_apps.sh
./6_deploy_secretless.sh
./7_deploy_k8s_provider.sh
./8_deploy_goapp_epv.sh

