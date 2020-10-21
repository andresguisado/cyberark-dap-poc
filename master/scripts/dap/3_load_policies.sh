#!/bin/bash

docker exec -it dap-cli bash -c "sh load_policies.sh >> /tmp/policies-output.json"
docker cp dap-cli:/tmp/policies-output.json `dirname "$0"`/../../.
