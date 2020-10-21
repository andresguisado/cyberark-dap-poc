#!/bin/bash

. `dirname "$0"`/../../.env

# Start the container
docker-compose up -d dap-cli

# Initializing the client
docker-compose exec dap-cli bash -c "yes yes | conjur init --url https://$DAP_FQDN --account $DAP_ACCOUNT"

# Interactive access
docker-compose exec dap-cli conjur authn login -u admin -p $DAP_ADMIN_PASSWORD
docker-compose exec dap-cli bash
