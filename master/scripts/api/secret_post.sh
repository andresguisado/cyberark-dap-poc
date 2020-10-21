#!/bin/bash

. `dirname "$0"`/utils.sh

function main(){
	echo "----"
	read -p "Please provide your DAP service URL (example: https://dap.cyberarkdemo.fr): " DAP_URL
	read -p "Please provide your DAP organization account (example: cybr): " DAP_ACCOUNT
	read -p "Please provide your DAP login: " DAP_LOGIN
	read -s -p "Please provide your DAP password: " DAP_PASSWORD; echo
	read -p "Please provide the secret path to fetch (example: dev/secrets/secret1): " DAP_SECRET_PATH
	read -s -p "Please provide the secret value: " DAP_SECRET_VALUE; echo
	echo "----"
	
	DAP_URL=${DAP_URL:=https://localhost}
	DAP_ACCOUNT=${DAP_ACCOUNT:=cybr}
	DAP_LOGIN=${DAP_LOGIN:=admin}
	DAP_PASSWORD=${DAP_PASSWORD:=CyberArk123!}
	DAP_SECRET_PATH=${DAP_SECRET_PATH:=dev/secrets/secret1}
	
	echo -e "[INFO] Generating API Key for $DAP_LOGIN"
	api_key=`get_api_key`
	
	echo -e "[INFO] Generating Access Token"
	token=`get_token`
	
	echo -e "[INFO] Setting Secret $DAP_SECRET_PATH"
	post_secret

	echo -e "[INFO] Secret value is now: `get_secret`" 

}

main
