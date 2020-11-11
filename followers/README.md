# Followers

## Usage
- The ``` vars.sh ``` file needs to be updated accordingly to your environment.

### Pre-requisites

- Create namespace/project:
```bash
$ kubectl create ns cyberark
```

```bash
$ oc create project cyberark
```

- Create Docker registry secret(This step is only needed if you are using a private docker registry):
```bash
$ kubectl create secret docker-registry docker-hub-registry --docker-server=index.docker.io/v1 --docker-username=andresguisado --docker-password="mypassword" --docker-email=myuser@gmail.com  -n cyberark
```

```bash
oc create secret docker-registry docker-hub-registry --docker-server=index.docker.io/v1 --docker-username=andresguisado --docker-password="mypassword" --docker-email=myuser@gmail.com  -n cyberark
```

- Update the following env vars within ```vars.sh``` file:

```
CONJUR_APPLIANCE_IMAGE
CONJUR_APPLIANCE_URL
PLATFORM
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