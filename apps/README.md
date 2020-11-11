# Applications

## Usage
- The ``` vars.sh ``` file needs to be updated accordingly to your environment.
- Scripts have an order that needs to be followed.

### Pre-requisites

- Create namespace/project:
```bash
$ kubectl create ns demoapps
```

```bash
$ oc create project demoapps
```

- Create Docker registry secret:

**Note**: This step is only needed if you are using a private docker container registry. If you are using docker hub(public or private) remove ```--docker-server``` flag.

```bash
$ kubectl create secret docker-registry docker-hub-registry --docker-server=your-docker-server --docker-username=your-username --docker-password="mypassword" --docker-email=myuser@plangiro.com  -n demoapps
```

```bash
oc create secret docker-registry docker-hub-registry --docker-server=index.docker.io/v1 --docker-username=andresguisado --docker-password="mypassword" --docker-email=myuser@plangiro.com -n demoapps
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