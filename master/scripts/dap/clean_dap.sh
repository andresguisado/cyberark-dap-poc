#!/bin/bash

docker-compose rm --stop --force dap-master dap-cli
rm `dirname "$0"`/../../.env
rm `dirname "$0"`/../../policies-output.json
