 #!/bin/bash
set -euo pipefail
. utils.sh  

echo "Deleting configmap"
$cli delete --ignore-not-found configmap -n $CONJUR_NAMESPACE dap-certificate
echo "Deleting deployment"
$cli delete --ignore-not-found deployment -n $CONJUR_NAMESPACE dap-follower
echo "Deleting role"
$cli delete --ignore-not-found role -n $CONJUR_NAMESPACE dap-authenticator-$CONJUR_NAMESPACE
echo "Deleting rolebinding"
$cli delete --ignore-not-found rolebinding -n $CONJUR_NAMESPACE dap-authenticator-role-binding-$CONJUR_NAMESPACE
echo "Deleting Service Account"
$cli delete --ignore-not-found sa -n $CONJUR_NAMESPACE dap-cluster

echo "Conjur environment purged."
