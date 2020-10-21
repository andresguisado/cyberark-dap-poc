FROM jenkins/jenkins:lts-centos

COPY plugins.txt /usr/share/jenkins/plugins.txt
COPY cyberark-conjur-1.0.6.tar.gz /tmp

RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

USER root
RUN yum install -y ansible
#COPY entrypoint.sh /tmp/entrypoint.sh

#ENTRYPOINT ["/bin/bash", "/tmp/entrypoint.sh"]
#USER jenkins
#CMD ansible-galaxy collection install /tmp/cyberark-conjur-1.0.5.tar.gz -p $JENKINS_HOME/.ansible/collections
#RUN mkdir -p $JENKINS_HOME/.ansible/collections
#RUN ansible-galaxy collection install /tmp/cyberark-conjur-1.0.4.tar.gz -p $JENKINS_HOME/.ansible/collections
#RUN ansible-galaxy collection install cyberark.conjur

