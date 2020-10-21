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

# /conjur/authn-k8s/okd3-cluster1 [okd3-cluster1 authenticator configuration]
conjur policy load --replace conjur/authn-k8s/okd3-cluster1 conjur/authn-k8s/okd3-cluster1.yml

conjur policy load --replace conjur/authn-k8s/okd3-cluster1/followers conjur/authn-k8s/okd3-cluster1/followers.yml
conjur policy load --replace conjur/authn-k8s/okd3-cluster1/goapp conjur/authn-k8s/okd3-cluster1/goapp.yml
conjur policy load --replace conjur/authn-k8s/okd3-cluster1/java-init-db conjur/authn-k8s/okd3-cluster1/java-init-db.yml
conjur policy load --replace conjur/authn-k8s/okd3-cluster1/java-sidecar-db conjur/authn-k8s/okd3-cluster1/java-sidecar-db.yml
conjur policy load --replace conjur/authn-k8s/okd3-cluster1/secretless-db conjur/authn-k8s/okd3-cluster1/secretless-db.yml
conjur policy load --replace conjur/authn-k8s/okd3-cluster1/k8s-provider-db conjur/authn-k8s/okd3-cluster1/k8s-provider-db.yml
conjur policy load --replace conjur/authn-k8s/okd3-cluster1/goapp-epv conjur/authn-k8s/okd3-cluster1/goapp-epv.yml

# /conjur [okd3-cluster1 authenticator entitlements]
conjur policy load conjur conjur/authn-k8s-entitlements.yml

####################
### DEV Policies ###
####################

# /dev (Environment)
conjur policy load dev dev.yml

# /dev/cicd
conjur policy load dev/cicd dev/cicd.yml

# /dev/okd3-cluster1/
conjur policy load --replace dev/okd3-cluster1 dev/okd3-cluster1.yml
conjur policy load conjur dev/okd3-cluster1-entitlements.yml

###############################################################
###  DEVelopers CICD(Jenkins, Azure DevOps and Ansible AWX) ###
###############################################################
conjur policy load --replace dev/cicd/jenkins dev/cicd/jenkins.yml
conjur policy load --replace dev/cicd/azuredevops dev/cicd/azuredevops.yml
conjur policy load --replace dev/cicd/ansible dev/cicd/ansibleawx.yml

#################################
###  DEVelopers okd3-cluster1 ###
#################################

conjur policy load --replace dev/okd3-cluster1/goapp dev/okd3-cluster1/goapp.yml
conjur policy load --replace dev/okd3-cluster1/java-init-db dev/okd3-cluster1/java-init-db.yml
conjur policy load --replace dev/okd3-cluster1/java-sidecar-db dev/okd3-cluster1/java-sidecar-db.yml
conjur policy load --replace dev/okd3-cluster1/secretless-db dev/okd3-cluster1/secretless-db.yml
conjur policy load --replace dev/okd3-cluster1/k8s-provider-db dev/okd3-cluster1/k8s-provider-db.yml
#conjur policy load --replace dev/okd3-cluster1/goapp-epv dev/okd3-cluster1/goapp-epv.yml
#conjur policy load  epv dev/okd3-cluster1/goapp-epv-entitlements.yml