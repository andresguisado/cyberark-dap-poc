#!/bin/bash

function get_api_key(){
	local api_key=$(
		curl -s -k \
		--url $DAP_URL/authn/$DAP_ACCOUNT/login \
		--user $DAP_LOGIN:$DAP_PASSWORD
	)
	echo "$api_key"
}

function get_token(){
	local clear_token=$(
		curl -s -k -H "Content-Type: text/plain" -X POST \
		--url $DAP_URL/authn/$DAP_ACCOUNT/$DAP_LOGIN/authenticate \
		--data "$api_key"
	)
	local token=$(echo -n $clear_token | base64 | tr -d '\r\n')
	echo "$token"
}

function get_secret(){
	local secret=$(
		curl -s -k -X GET -H "Authorization: Token token=\"$token\"" \
		--url $DAP_URL/secrets/$DAP_ACCOUNT/variable/$DAP_SECRET_PATH
	)
	echo "$secret"
}

function post_secret(){
	local output=$(
		curl -s -k -H "Content-Type: text/plain" -H "Authorization: Token token=\"$token\"" -X POST \
		--url $DAP_URL/secrets/$DAP_ACCOUNT/variable/$DAP_SECRET_PATH \
		--data "$DAP_SECRET_VALUE"
	)
}

function load_policy(){
	local output=$(
		curl -s -k -H "Authorization: Token token=\"$token\"" -X POST \
		--url $DAP_URL/policies/$DAP_ACCOUNT/policy/$DAP_POLICY_PATH \
		--data "$(< ${DAP_POLICY_FILE_PATH})"
  )
  echo -e "$output"
}

function get_secrets_list(){
	local output=$(
		curl -s -k -H "Authorization: Token token=\"$token\"" -X GET \
  	--url $DAP_URL/resources/$DAP_ACCOUNT?kind=variable
	)
  echo -e "$output"
}

function get_secrets_list_for_an_host(){
	local host_id=$1
  local output=$(
		curl -s -k -H "Authorization: Token token=\"$token\"" -X GET \
  	--url $DAP_URL/resources/$DAP_ACCOUNT'?kind=variable&acting_as='$DAP_ACCOUNT':host:'$host_id
	)
  echo -e "$output"
}

function get_secrets_count_for_an_host(){
	local host_id=$1
	local output=$(
		curl -s -k -H "Authorization: Token token=\"$token\"" -X GET \
  	--url $DAP_URL/resources/$DAP_ACCOUNT'?kind=variable&count=true&acting_as='$DAP_ACCOUNT':host:'$host_id
	)
  echo -e "$output"
}

function check_host_can_retrieve_secret(){
  local host_id=$1
	local var_id=$2
  local output=$(
		curl -o /dev/null -s -w "%{http_code}\n" -k -H "Authorization: Token token=\"$token\"" -X GET \
    --url $DAP_URL'/resources/'$DAP_ACCOUNT'/variable/'$var_id'?check=true&role='$DAP_ACCOUNT':host:'$host_id'&privilege=execute'
	)
  echo -e "$output"
}

function get_hosts_list(){
	local search=$1
	if [[ -z "$search" ]];
	then
		local output=$(
			curl -s -k -H "Authorization: Token token=\"$token\"" -X GET \
    	--url $DAP_URL/resources/$DAP_ACCOUNT'?kind=host'
		)
	else
		local output=$(
			curl -s -k -H "Authorization: Token token=\"$token\"" -X GET \
    	--url $DAP_URL/resources/$DAP_ACCOUNT'?kind=host&search='$search
		)
	fi
	echo -e "$output"
}

function get_hosts_count(){
	local search=$1
	if [[ -z "$search" ]];
	then
		local output=$(
			curl -s -k -H "Authorization: Token token=\"$token\"" -X GET \
      --url $DAP_URL/resources/$DAP_ACCOUNT'?kind=host&count=true'
		)
  else
	  local output=$(
			curl -s -k -H "Authorization: Token token=\"$token\"" -X GET \
    	--url $DAP_URL/resources/$DAP_ACCOUNT'?kind=host&count=true&search='$search
		)
	fi
	echo -e "$output"
}

function rotate_api_key(){
	local output=$(
		curl -s -k -H "Authorization: Token token=\"$token\"" -X PUT \
		--data "" \
		--url $DAP_URL/authn/$DAP_ACCOUNT/api_key?role=$DAP_KIND:$DAP_ROLE_ID
	)
	echo -e "$output"
}
