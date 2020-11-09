#!/bin/bash

############
### ROOT ###
############

# /
conjur policy load root root.yml

#######################
### Conjur Policies ###
#######################

# /conjur 
conjur policy load conjur conjur.yml

##########################################
### CONJUR Authenticators(Webservices) ###
##########################################

# /conjurt [Enabling Authenticators]
conjur policy load conjur/authn-k8s conjur/authn-k8s.yml

# /conjur/seed-generation
conjur policy load conjur/seed-generation conjur/seed-generation.yml

# /conjur/authn-k8s/k8s-cluster1 [k8s-cluster1 authenticator configuration]
conjur policy load --replace conjur/authn-k8s/k8s-cluster1 conjur/authn-k8s/k8s-cluster1.yml

conjur policy load --replace conjur/authn-k8s/k8s-cluster1/followers conjur/authn-k8s/k8s-cluster1/followers.yml
conjur policy load --replace conjur/authn-k8s/k8s-cluster1/goapp conjur/authn-k8s/k8s-cluster1/goapp.yml
conjur policy load --replace conjur/authn-k8s/k8s-cluster1/java-init-db conjur/authn-k8s/k8s-cluster1/java-init-db.yml
conjur policy load --replace conjur/authn-k8s/k8s-cluster1/java-sidecar-db conjur/authn-k8s/k8s-cluster1/java-sidecar-db.yml
conjur policy load --replace conjur/authn-k8s/k8s-cluster1/secretless-db conjur/authn-k8s/k8s-cluster1/secretless-db.yml
conjur policy load --replace conjur/authn-k8s/k8s-cluster1/k8s-provider-db conjur/authn-k8s/k8s-cluster1/k8s-provider-db.yml
conjur policy load --replace conjur/authn-k8s/k8s-cluster1/goapp-epv conjur/authn-k8s/k8s-cluster1/goapp-epv.yml

# /conjur [k8s-cluster1 authenticator entitlements]
conjur policy load conjur conjur/authn-k8s-entitlements.yml

####################
### DEV Policies ###
####################

# /dev (Environment)
conjur policy load dev dev.yml

# /dev/cicd
conjur policy load dev/cicd dev/cicd.yml

# /dev/k8s-cluster1/
conjur policy load --replace dev/k8s-cluster1 dev/k8s-cluster1.yml
conjur policy load conjur dev/k8s-cluster1-entitlements.yml

###############################################################
###  DEVelopers CICD(Jenkins, Azure DevOps and Ansible AWX) ###
###############################################################
conjur policy load --replace dev/cicd/jenkins dev/cicd/jenkins.yml
conjur policy load --replace dev/cicd/azuredevops dev/cicd/azuredevops.yml
conjur policy load --replace dev/cicd/ansible dev/cicd/ansibleawx.yml

#################################
###  DEVelopers k8s-cluster1 ###
#################################

conjur policy load --replace dev/k8s-cluster1/goapp dev/k8s-cluster1/goapp.yml
conjur policy load --replace dev/k8s-cluster1/java-init-db dev/k8s-cluster1/java-init-db.yml
conjur policy load --replace dev/k8s-cluster1/java-sidecar-db dev/k8s-cluster1/java-sidecar-db.yml
conjur policy load --replace dev/k8s-cluster1/secretless-db dev/k8s-cluster1/secretless-db.yml
conjur policy load --replace dev/k8s-cluster1/k8s-provider-db dev/k8s-cluster1/k8s-provider-db.yml
#conjur policy load --replace dev/k8s-cluster1/goapp-epv dev/k8s-cluster1/goapp-epv.yml
#conjur policy load  epv dev/k8s-cluster1/goapp-epv-entitlements.yml