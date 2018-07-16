#!/bin/sh

if [ ! -z "$USERNAME" ] && [ ! -z "$USERPASSWORD" ]; then
  # Add user account with environment variable
  useradd -m $USERNAME
  echo "$USERNAME:$USERPASSWORD" | chpasswd
fi

if [ ! -z "$ROOTPASSWORD" ]; then
  echo "root:$ROOTPASSWORD" | chpasswd
fi

if [ ! -z "$ROOTLOGIN" ]; then
  sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
fi

/usr/sbin/sshd -D

