#!/bin/bash

. `dirname "$0"`/utils.sh

function main(){
	echo "----"
	read -p "Please provide your DAP service URL (example: https://dap.cyberarkdemo.fr): " DAP_URL
	read -p "Please provide your DAP organization account (example: cybr): " DAP_ACCOUNT
	read -p "Please provide your DAP login: " DAP_LOGIN
	read -s -p "Please provide your DAP password: " DAP_PASSWORD; echo
	read -p "Please provide DAP kind (host, user, ...) of the role to update: " DAP_KIND
	read -p "Please provide the DAP role ID: " DAP_ROLE_ID
	echo "----"
	
	DAP_URL=${DAP_URL:=https://localhost}
	DAP_ACCOUNT=${DAP_ACCOUNT:=cybr}
	DAP_LOGIN=${DAP_LOGIN:=admin}
	DAP_PASSWORD=${DAP_PASSWORD:=CyberArk123!}
	DAP_KIND=${DAP_KIND:=host}
	DAP_ROLE_ID=${DAP_ROLE_ID:=myhost}	
	echo -e "[INFO] Generating API Key for $DAP_LOGIN"
	api_key=`get_api_key`
	
	echo -e "[INFO] Generating Access Token"
	token=`get_token`
	
	echo -e "[INFO] New  API KEY for $DAP_KIND $DAP_ROLE_ID is: `rotate_api_key`" 

}

main
