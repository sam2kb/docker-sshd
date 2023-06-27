#!/bin/sh

SSH_HOST_KEYS="/etc/ssh/ssh_host_*"
SSH_HOST_PUB_KEYS="/etc/ssh/ssh_host_*.pub"
SSH_DIR="/home/$SSH_USER/.ssh"
SSH_AUTH="$SSH_DIR/authorized_keys"

if [ -n "$(echo $SSH_HOST_KEYS)" ]; then
  # Fix permissions on host keys
  chmod 600 $SSH_HOST_KEYS
  chown root:root $SSH_HOST_KEYS
  if [ -n "$(echo $SSH_HOST_PUB_KEYS)" ]; then
    # Fix permissions on host public keys
    chmod 644 $SSH_HOST_PUB_KEYS
    chown root:root $SSH_HOST_PUB_KEYS
  fi
else
  # Generate new host keys
  ssh-keygen -A
fi

if [ -f "$SSH_AUTH" ]; then
  # Fix permissions on mounted authorized_keys file
  chmod 600 "$SSH_AUTH"
  chown $SSH_USER:$SSH_USER "$SSH_AUTH"
  /usr/sbin/sshd -D -e "$@"
else
  echo "File not found, cannot proceed: $SSH_AUTH"
fi
