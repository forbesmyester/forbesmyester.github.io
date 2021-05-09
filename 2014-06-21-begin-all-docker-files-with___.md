# Begin all Docker files with...



I've just had an extremely frustrating mostly wasted day with Docker. It turns out that, at least with Ubuntu 14.04 the root user is quite messed up, for example it's home directory ends up being just `/` and worse than that putting files like `.ssh/known_hosts` in the root (or `/root`) just does not work, at least for Git checkouts over SSH. I think this is the most elegant solution:

```
FROM ubuntu:14.04
MAINTAINER YOUR_NAME

RUN useradd -m -s /bin/bash ubuntu
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/10-ubuntu_no_password

# Uncomment the following for cool provisioning...
# RUN sudo su ubuntu -c "ansible-playbook -c local playbook.yml"
```

Honestly it took me far to long to come round to this solution, probably because I'm used to Amazon and Vagrant which both give you a working evironment when the machine boots... of course Docker doesn't technically "boot" but I'm not too impressed with how broken it is by default.

Docker bug open since November: [https://github.com/dotcloud/docker/issues/2968](https://github.com/dotcloud/docker/issues/2968)

