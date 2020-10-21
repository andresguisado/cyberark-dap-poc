#!/bin/bash

ENV_PATH=`dirname "$0"`/../../.env

truncate -s 0 $ENV_PATH

read -p "Enter DAP FQDN (default: localhost):" DAP_FQDN
echo "DAP_FQDN=${DAP_FQDN:=localhost}" >> $ENV_PATH 

read -p "Enter DAP ALTNAMES (default: localhost):" DAP_ALTNAMES
echo "DAP_ALTNAMES=${DAP_ALTNAMES:=localhost}" >> $ENV_PATH 

read -p "Enter DAP Organization (default: cybr):" DAP_ACCOUNT
echo "DAP_ACCOUNT=${DAP_ACCOUNT:=cybr}" >> $ENV_PATH

read -p "Enter DAP Admin Password (default: CYberark11!!):" DAP_ADMIN_PASSWORD
echo "DAP_ADMIN_PASSWORD=${DAP_ADMIN_PASSWORD:=CYberark11!!}" >> $ENV_PATH