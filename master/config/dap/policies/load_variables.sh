#!/bin/bash

#Secrets

# /dev/cicd/jenkins
conjur variable values add dev/cicd/jenkins/access_key_id  XXXXXX
conjur variable values add dev/cicd/jenkins/access_key_secret YYYYY
conjur variable values add dev/cicd/jenkins/targetuser root
conjur variable values add dev/cicd/jenkins/targetpwd Cyberark1
conjur variable values add dev/cicd/jenkins/targetsshkey $targetsshkey

# /dev/cicd/azuredevops
conjur variable values add dev/cicd/azuredevops/access_key_id  XXXXXX
conjur variable values add dev/cicd/azuredevops/access_key_secret YYYYY
conjur variable values add dev/cicd/azuredevops/targetuser root
conjur variable values add dev/cicd/azuredevops/targetpwd Cyberark1
conjur variable values add dev/cicd/azuredevops/targetsshkey $targetsshkey