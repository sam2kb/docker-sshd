FROM debian:12-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-server curl iputils-ping && \
    rm -rf /var/lib/apt/lists/* &&\
    rm -f /etc/ssh/ssh_host_*key* && \
    mkdir /run/sshd && \
    chmod 0755 /run/sshd

COPY sshd_config /etc/ssh/
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
