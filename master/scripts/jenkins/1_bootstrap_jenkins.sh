#!/bin/bash

. `dirname "$0"`/../../.env

echo "[INFO] Starting Jenkins"
docker-compose up -d jenkins
docker-compose exec jenkins bash -c "ansible-galaxy collection install /tmp/cyberark-conjur-1.0.7.tar.gz -p /root/.ansible/collections"
docker-compose exec jenkins bash -c "ansible-galaxy collection install /tmp/cyberark-conjur-1.0.7.tar.gz -p $JENKINS_HOME/.ansible/collections"
docker-compose exec jenkins bash -c "openssl s_client -showcerts -connect dap-master:443 < /dev/null 2> /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $JENKINS_HOME/dap-cert.pem"
docker-compose exec jenkins bash -c "yes | keytool -import -alias conjur -file $JENKINS_HOME/dap-cert.pem -keystore /etc/alternatives/jre_openjdk/lib/security/cacerts -storepass changeit"
docker-compose exec jenkins bash -c "rm $JENKINS_HOME/dap-cert.pem"
echo "--------------------------"
echo "Jenkins admin password is:"
echo "--------------------------"
sleep 5
docker-compose exec jenkins bash -c "cat /var/jenkins_home/secrets/initialAdminPassword"
docker-compose exec jenkins bash -c "cat /var/jenkins_home/secrets/initialAdminPassword >> /tmp/jenkins-admin-pwd.txt"
docker cp jenkins:/tmp/jenkins-admin-pwd.txt `dirname "$0"`/../../.