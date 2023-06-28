#!/bin/sh

KEYS=/etc/ssh/keys

echo "Setting a '$SSH_USER' account with a random password"
useradd -s /bin/bash -m $SSH_USER
echo "$SSH_USER:$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 40)" | chpasswd

mkdir -p $KEYS
chmod 755 $KEYS

if [ ! -f "$KEYS/ssh_host_ed25519_key" ] || [ ! -f "$KEYS/ssh_host_rsa_key" ]; then
  echo "Generating new host keys"
  ssh-keygen -t ed25519 -f "$KEYS/ssh_host_ed25519_key" -q -N ''
  ssh-keygen -t rsa -b 4096 -f "$KEYS/ssh_host_rsa_key" -q -N ''
else
  echo "Fixing permissions for attached key files"
  chmod 600 "$KEYS/ssh_host_ed25519_key" || true
  chmod 600 "$KEYS/ssh_host_rsa_key" || true
fi

if [ -f "$KEYS/authorized_keys" ]; then
  echo "Fixing permissions for authorized_keys file"
  chmod 644 "$KEYS/authorized_keys"
  sed -i "s/^\(#\)\?\(AllowUsers\).*/\2 $SSH_USER/" /etc/ssh/sshd_config
  /usr/sbin/sshd -D -e "$@"
else
  echo "You must provide the authorized_keys file: $KEYS/authorized_keys"
fi
