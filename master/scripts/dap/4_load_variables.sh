#!/bin/bash
export targetsshkey=$(cat config/ansible-target/target_priv_key)
docker exec -it dap-cli -e targetsshkey=$targetsshkey bash -c "sh load_variables.sh"

