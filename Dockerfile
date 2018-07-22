FROM       ubuntu:18.04

MAINTAINER "Alex <ualex73@gmail.com>"

COPY rootfs/* /

RUN apt-get update && \
    apt-get install -y openssh-server fail2ban rsyslog sudo apg && \
    mkdir /var/run/sshd && \
    mkdir /root/.ssh && \
    echo 'root:root' | chpasswd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -f /etc/ssh/ssh_host_* && \
    mkdir /config && \
    touch /var/log/auth.log && \
    chown syslog:adm /var/log/auth.log && \
    sed -i "s/^module(load=\"imklog\"/#module(load=\"imklog\"/" /etc/rsyslog.conf && \
    chmod a+x /run.sh

#RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
#RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/run.sh"]
