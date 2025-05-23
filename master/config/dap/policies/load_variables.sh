#!/bin/bash

#Secrets

# /dev/cicd/ansible
conjur variable values add dev/cicd/ansible/access_key_id  XXXXXX
conjur variable values add dev/cicd/ansible/access_key_secret YYYYY
conjur variable values add dev/cicd/ansible/targetuser root
conjur variable values add dev/cicd/ansible/targetpwd Cyberark1
conjur variable values add dev/cicd/ansible/targetsshkey test

# /dev/cicd/jenkins
conjur variable values add dev/cicd/jenkins/access_key_id  XXXXXX
conjur variable values add dev/cicd/jenkins/access_key_secret YYYYY
conjur variable values add dev/cicd/jenkins/targetuser root
conjur variable values add dev/cicd/jenkins/targetpwd Cyberark1
conjur variable values add dev/cicd/jenkins/targetsshkey test

# /dev/cicd/azuredevops
conjur variable values add dev/cicd/azuredevops/access_key_id  XXXXXX
conjur variable values add dev/cicd/azuredevops/access_key_secret YYYYY
conjur variable values add dev/cicd/azuredevops/targetuser root
conjur variable values add dev/cicd/azuredevops/targetpwd Cyberark1
conjur variable values add dev/cicd/azuredevops/targetsshkey test