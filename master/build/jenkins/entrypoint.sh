#!/bin/bash

#/usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
#ansible-galaxy collection install /tmp/cyberark-conjur-1.0.7.tar.gz -p $JENKINS_HOME/.ansible/collections
ansible-galaxy collection install cyberark.conjur
tail -f /dev/null