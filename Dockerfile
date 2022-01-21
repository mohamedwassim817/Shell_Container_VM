FROM debian:10

ENV container docker

ENV LC_ALL C

ENV DEBIAN_FRONTEND noninteractive

RUN echo 'deb http://deb.debian.org/debian stretch-backports main' >> /etc/apt/sources.list

RUN apt-get update \
    && apt-get install -y --no-install-recommends systemd python3 sudo bash net-tools openssh-server openssh-client vim git\
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config


RUN ln -s /lib/systemd/system /sbin/init

RUN sed -i 's#root:\*#root:sa3tHJ3/KuYvI#' /etc/shadow
ENV init /lib/systemd/systemd
VOLUME [ "/sys/fs/cgroup" ]
RUN systemctl set-default multi-user.target
ENTRYPOINT ["/lib/systemd/systemd"]

