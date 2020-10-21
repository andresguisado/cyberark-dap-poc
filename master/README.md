# Master POC

## Introduction

This project aims to package CyberArk DAP installation & configuration with several basic use cases.

The folder structure is defined as follows:
```bash
.
├── build			# Files used for building docker images (Dockerfiles, entrypoints,...)
├── config			# Configuration files mounted in docker containers (eg: parameters files, env variables)
├── docker-compose.yaml		# Docker compose file
├── README.md			# You are HERE!
├── scripts			# Scripts to launch and configure the containers
└── storage			# Folders mounted in containers to store data
```


## Requirements

### Docker

[Docker installation documentation](https://docs.docker.com/install/)  
[Docker Compose installation documentation](https://docs.docker.com/compose/install/)  

### DAP docker image

This project requires the DAP docker image. Install it with the following command:

```bash
$ docker load -i conjur-appliance-<version>.tar.gz
```

# Usage

## Start DAP

### Set required parameters
- You are asked to provide an alternative name (like dap.cyberarkdemo.com) that resolves the host. The default value is ***localhost***.
- You are asked to provide a DAP organization name (like my-company) that reflects your organization. The default value is ***cybr***.
- You are asked to provide a password for the built-in admin user (like Str0ngPw!). The default value is ***Cyberark1***.
```bash
$ ./scripts/dap/0_bootstrap_env.sh
```

#### Step 1 

- Start and configure the DAP master container 
```bash
$ ./scripts/dap/1_bootstrap_dap_master.sh
```

#### Step 2 

- Run the cli container using:
```bash
$ ./scripts/dap/2_bootstrap_dap_cli.sh
```
- You are now into the conjur cli container, type `conjur authn whoami` to verify it's working.
- You can exit the container (command *exit*). To access to the container back, run:
```bash
$ ./scripts/dap/start_dap_cli.sh
```
or type:
```bash
$ docker-compose exec dap-cli bash
```
#### Step 3
- Load policies using:
```bash
$ ./scripts/dap/3_load_policies.sh
```
- You can now access the conjur cli container and type `conjur list` to verify resources creation.
- Loading the policies will generate an output file ***policies-output.json*** located at this project root.

#### Step 4
- Load some sample variables/secrets using:
```bash
$ ./scripts/dap/4_load_variables.sh
```

#### Step 5
- Enable authenticators using:
```bash
$ ./scripts/dap/5_enable_master_authn.sh
```

## Start Jenkins

### Set required parameters

```bash
$ ./scripts/jenkins/1_bootstrap_env.sh
```

#### Step 1 

- Start and configure the jenkins container 
```bash
$ ./scripts/jenkins/1_bootstrap_jenkins.sh
```