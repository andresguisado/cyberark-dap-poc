#!/bin/bash

. `dirname "$0"`/../../.env

echo "[INFO] Enabling Autenticator"
docker exec dap-master bash -c "evoke variable set CONJUR_AUTHENTICATORS authn"



