FROM debian:latest

RUN apt update
RUN apt-get install -y openssh-server --no-install-recommends
RUN apt-get install -y python3
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo 'root:Cyberark1' | chpasswd
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

