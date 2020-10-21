#!/bin/bash

mkdir -p /root/.ssh 
chmod 700 /root/.ssh
touch /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDa6eRqD5o/F0/HFhYd39/JJsm34fPpKFMICSeq45yJvj6GkQx11aifmGWB5iFODzj8SfVZZWFpeuDT9w5u7RktQBmu7yCAxcPslI9Rszi/ehwkfDRi4LHd9iXovrA+V5wKXqlg5jX5C19UQv4gc2ilD2N840+9a7TiR4NsfxJwGwfFtpe5YGKJ7FJZGKanZwB2AwIzZdvGyknpazr2Cwam6cQH8iD4LpQCnGZj7+slrxcaC+o0DL094U7/65kdmoChUgxLz9+3Ers7gXjQa+Jfl3YVHiODck1s0cYcgrcsx+yloge4k3Yx3bOR5oAr1xb9Pjr+04neNg8NDZsTvp7f > /root/.ssh/authorized_keys 
service ssh start
tail -f /dev/null
