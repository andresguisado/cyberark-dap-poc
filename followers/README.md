# Conjur Openshift4 Followers POC

## Usage
- The ``` <k8s-cluster-name>-config.sh ``` file needs to be updated accordingly to your environment.
- Scripts have an order that needs to be followed.
- Cleaning scripts can be used to clean all or part of what has been deployed.

### Pre-requisite

```bash
$ kubectl create ns cyberark
```

```bash
$ kubectl create secret docker-registry docker-hub-registry --docker-username=andresguisado --docker-password="mypassword" --docker-email=myuser@gmail.com --docker-server=index.docker.io/v1 -n cyberark
```

### Start

```bash
$ source vars.sh
```

```bash
$ ./start.sh
```

### Stop

```bash
$ ./stop.sh
```