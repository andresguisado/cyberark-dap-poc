#!/bin/bash

. `dirname "$0"`/utils.sh

function main(){
	echo "----"
	read -p "Please provide your DAP service URL (example: https://dap.cyberarkdemo.fr): " DAP_URL
	read -p "Please provide your DAP organization account (example: cybr): " DAP_ACCOUNT
	read -p "Please provide your DAP login: " DAP_LOGIN
	read -s -p "Please provide your DAP password: " DAP_PASSWORD; echo
	read -p "Please provide the path to your DAP policy (default: ./policy.yml): " DAP_POLICY_FILE_PATH
	read -p "Please provide the policy id that you would like to modify (example: dev/secrets): " DAP_POLICY_PATH
	echo "----"
	
	DAP_URL=${DAP_URL:=https://localhost}
	DAP_ACCOUNT=${DAP_ACCOUNT:=cybr}
	DAP_LOGIN=${DAP_LOGIN:=admin}
	DAP_PASSWORD=${DAP_PASSWORD:=CyberArk123!}
	DAP_POLICY_FILE_PATH=${DAP_POLICY_FILE_PATH:=./policy.yml}
	DAP_POLICY_PATH=${DAP_POLICY_PATH:=dev/secrets}
	
	echo -e "[INFO] Generating API Key for $DAP_LOGIN"
	api_key=`get_api_key`
	
	echo -e "[INFO] Generating Access Token"
	token=`get_token`
	
	echo -e "[INFO] Loading Policy under $DAP_POLICY_PATH"
	policy_output=`load_policy`
	echo -e "$policy_output"
}

main
