#!/bin/bash

echo "[INFO] Master Healthcheck"
curl https://localhost/health --insecure 
