FROM jenkins/jenkins:lts-centos

#COPY plugins.txt /usr/share/jenkins/plugins.txt
COPY cyberark-conjur-1.0.7.tar.gz /tmp
#COPY entrypoint.sh /tmp/entrypoint.sh

#RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

USER root
RUN yum install -y python3-pip
RUN pip3 install ansible
RUN dnf install epel-release -y
RUN dnf makecache
RUN dnf install sshpass -y
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin
#USER jenkins
#RUN ansible-galaxy collection install cyberark.conjur
#RUN mkdir -p $JENKINS_HOME/.ansible/collections
#RUN ansible-galaxy collection install /tmp/cyberark-conjur-1.0.7.tar.gz -p $JENKINS_HOME/.ansible/collections


#ENTRYPOINT ["/bin/bash", "/tmp/entrypoint.sh"]


