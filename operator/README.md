# OpenShift DAP Operator

## Steps

```bash
1- Create service account
2- Create configmap
3- Initialize ca for the authenticator 
4- Enable authenticator
5- Add Kubernetes varibales for seedfetcher and authentication out of k8s
6- Create Authenticator Role 
7- Create Authenticator Role Binding
8- Create Operator Role
9- Createa Operator Role Binding
10- Create CRD
11- Deploy Operator(change container image in yaml)
12- Deploy CR
```

## Sample `DAPFollower` Manifest

The `DAPFollower` manifest spec contains the configuration settings for a
DAP Follower deployed using the operator.

```yaml
apiVersion: dap.cyberark.com/v1alpha1
kind: DAPFollower
metadata:
  name: my-company-dapfollower
spec:
  clusterRoleName: cyberark-dap-authenticator
  conjurAccount: my-company
  conjurAuthnLogin: host/service-account-host-path
  dapMasterHostname: dap-master.my-company.net
  authenticatorId: dap-follower
  clusterRoleBindingName: cyberark-dap-follower
  configMapName: cyberark-dap-follower
  deploymentName: dap-follower
  followerReplicas: 1
  images:
    conjur: docker-registry.default.svc:5000/cyberark-dap-follower/conjur
    postgres: docker-registry.default.svc:5000/cyberark-dap-follower/postgres
    info: docker-registry.default.svc:5000/cyberark-dap-follower/info
    seedFetcher: docker-registry.default.svc:5000/cyberark-dap-follower/seedfetcher
    nginx: docker-registry.default.svc:5000/cyberark-dap-follower/nginx
    syslogNg: docker-registry.default.svc:5000/cyberark-dap-follower/syslog-ng
```

The following parameters are **required** in the spec:

| Name                     | Purpose                                                     | Example                                                              |
| ------------------------ | ------------------------------------------------------------| ---------------------------------------------------------------------|
| `dapMasterHostname`      | The public hostname at which the DAP Master can be reached. | `dap.my-company.net`                                                 |
| `conjurAccount`          | Account name used when setting up the DAP Master.           | Provided when configuring the DAP Master (e.g. `my-company`).        |
| `conjurAuthnLogin`       | Conjur host identity used for authentication and seed file retrieval. The host identity should be prefixed with `host/` .          | `host/ocp/dap-follower`    |
| `images/seedFetcher`     | Docker registry URL for the Seedfetcher image.              | `docker-registry.default.svc:5000/cyberark-dap-follower/seedfetcher` |
| `images/postgres`        | Docker registry URL for the Postgres image.                 | `docker-registry.default.svc:5000/cyberark-dap-follower/postgres`    |
| `images/syslogNg`        | Docker registry URL for the Syslog-ng image.                | `docker-registry.default.svc:5000/cyberark-dap-follower/syslog-ng`   |
| `images/conjur`          | Docker registry URL for the Conjur image.                   | `docker-registry.default.svc:5000/cyberark-dap-follower/conjur`      |
| `images/nginx`           | Docker registry URL for the Nginx image.                    | `docker-registry.default.svc:5000/cyberark-dap-follower/nginx`       |
| `images/info`            | Docker registry URL for the Info service image.             | `docker-registry.default.svc:5000/cyberark-dap-follower/info`        |

The parameters below are **optional** in the spec. If they are not included, the default value is used:

*NOTE: Only `followerReplicas` may be updated after initially creating a follower.
Modifying other parameters will not affect the existing secondary OpenShift resources.*

| Name                     | Purpose                                                                    | Default Value           |
| ------------------------ | ---------------------------------------------------------------------------| ------------------------|
| `serviceAccountName`     | Name of the Service Account the operator will create for the Follower.     | `cyberark-dap-follower` |
| `clusterRoleName`        | Name of the Cluster Role the operator will use or create.                  | `cyberark-dap-authenticator`                                         |
| `clusterRoleBindingName` | Name of the Cluster Role Binding the operator will create.                 | `cyberark-dap-follower` |
| `serviceName`            | Name of the Service the operator will create for the Follower.             | `cyberark-dap-follower` |
| `deploymentName`         | Name of the Deployment the operator will create for the Follower.          | `dap-follower`          |
| `followerReplicas`       | Number of Follower pods to deploy.                                         | `1`                     |
| `configMapName`          | Name of the config map where the DAP Master certificate CA is stored.      | `cyberark-dap-follower` |
| `authenticatorId`        | Name of the authenticator service in the DAP master the Follower will use. | `dap-follower`          |


## Troubleshooting and Debugging

### Operator Logs

The operator logs are the primary means for troubleshooting and debugging the
operator behavior. The logs are output from the deployed operator pod, either from
the OpenShift web console or the OpenShift CLI.

This is an example of retrieving the logs using the OpenShift CLI:
```sh-session
$ oc logs <operator pod name>
{"level":"info","ts":1579716918.7686386,"logger":"cmd","msg":"Operator Version: 0.0.1"}
{"level":"info","ts":1579716918.7686872,"logger":"cmd","msg":"Go Version: go1.13.5"}
{"level":"info","ts":1579716918.7686996,"logger":"cmd","msg":"Go OS/Arch: linux/amd64"}
{"level":"info","ts":1579716918.768707,"logger":"cmd","msg":"Version of operator-sdk: v0.12.0"}
...
{"level":"info","ts":1579716921.904431,"logger":"controller-runtime.controller","msg":"Starting Controller","controller":"dapfollower-controller"}
{"level":"info","ts":1579716922.0045838,"logger":"controller-runtime.controller","msg":"Starting workers","controller":"dapfollower-controller","worker count":1}
```

Each log message is a JSON string containing the following fields:

| Field    | Description                                          |
| -------- | ---------------------------------------------------- |
| `level`  | Severity of the log message (e.g. `info`, `error` ). |
| `ts`     | Timestamp for the log message.                       |
| `logger` | Operator component that produced the log message.    |
| `msg`    | The body of the log message.                         |

The JSON string may also contain additional fields specific to the particular
`logger`. For example, log messages recording the creation of secondary resources
may contain fields such as `Deployment.Namespace` and `Deployment.Name` to further
describe the log context.

Log messages specific to the DAP Operator will use the `logger` titled
`controller_dapfollower`. For example:
```
{"level":"info","ts":1579717314.4122217,"logger":"controller_dapfollower","msg":"Reconciling DAPFollower","Request.Namespace":"my-dap-operator","Request.Name":"dap-follower"}
{"level":"info","ts":1579717314.4122999,"logger":"controller_dapfollower","msg":"DAP Follower resource reconciled."}
```