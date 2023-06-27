FROM debian:12-slim

ARG SSH_USER
ENV SSH_USER=$SSH_USER

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m $SSH_USER \
    && mkdir /home/$SSH_USER/.ssh \
    && chown $SSH_USER:$SSH_USER /home/$SSH_USER/.ssh \
    && chmod 700 /home/$SSH_USER/.ssh \
    && mkdir /run/sshd \
    && chmod 0755 /run/sshd

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
