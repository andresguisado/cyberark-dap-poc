FROM jenkins/jenkins:lts-centos

#COPY plugins.txt /usr/share/jenkins/plugins.txt
COPY cyberark-conjur-1.0.7.tar.gz /tmp
#COPY entrypoint.sh /tmp/entrypoint.sh

#RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

USER root
RUN yum install -y python3-pip \
    && pip3 install ansible \
    && dnf install epel-release -y \
    && dnf makecache \
    && dnf install sshpass -y \
    && curl -fsSL https://get.docker.com -o get-docker.sh \
    && sh get-docker.sh \
    && usermod -aG docker jenkins \
    && rm get-docker.sh \
    && curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin
#USER jenkins
#RUN ansible-galaxy collection install cyberark.conjur \
# && mkdir -p $JENKINS_HOME/.ansible/collections \
# && ansible-galaxy collection install /tmp/cyberark-conjur-1.0.7.tar.gz -p $JENKINS_HOME/.ansible/collections


#ENTRYPOINT ["/bin/bash", "/tmp/entrypoint.sh"]


