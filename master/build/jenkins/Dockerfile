FROM jenkins/jenkins:lts-centos

#COPY plugins.txt /usr/share/jenkins/plugins.txt
COPY cyberark-conjur-1.0.7.tar.gz /tmp
#COPY entrypoint.sh /tmp/entrypoint.sh

#RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

USER root
RUN yum install -y python3-pip
RUN pip3 install ansible
#USER jenkins
#RUN ansible-galaxy collection install cyberark.conjur
#RUN mkdir -p $JENKINS_HOME/.ansible/collections
#RUN ansible-galaxy collection install /tmp/cyberark-conjur-1.0.7.tar.gz -p $JENKINS_HOME/.ansible/collections


#ENTRYPOINT ["/bin/bash", "/tmp/entrypoint.sh"]


