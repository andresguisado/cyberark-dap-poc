#!/bin/bash

#/usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
#yum install -y ansible
#RUN mkdir -p $JENKINS_HOME/.ansible/collections
ansible-galaxy collection install /tmp/cyberark-conjur-1.0.5.tar.gz -p $JENKINS_HOME/.ansible/collections
tail -f /dev/null
#ansible-galaxy collection install cyberark.conjur