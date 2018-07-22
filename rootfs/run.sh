#!/bin/bash

if [ ! -z "$USERNAME" ] && [ ! -z "$USERPASSWORD" ]; then
  # Add user account with environment variable
  useradd -m $USERNAME -s /bin/bash
  echo "$USERNAME:$USERPASSWORD" | chpasswd

  if [ "$USERSUDO" == "yes" ]; then
    adduser "$USERNAME" sudo
  fi
fi

if [ ! -z "$ROOTPASSWORD" ]; then
  echo "root:$ROOTPASSWORD" | chpasswd
else
  # Set a random password
  PASS=`apg -n 1 -m 16`
  echo "root:$PASS" | chpasswd
  echo "INFO: Random 'root' password is '$PASS'"
fi

# Allow root login only when requested
if [ "$ROOTLOGIN" == "yes" ]; then
  sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
fi

# Copy ssh_host_* keys from own directory ...
if [ -f "/config/.generated" ]; then
  echo "INFO: Copied SSH keys from /config to /etc/ssh"
  touch /etc/ssh/.generated
  cp -p /config/ssh_host_* /etc/ssh
fi

# Regenerate SSH keys if they are missing
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
  echo "INFO: Generating SSH keys"
  dpkg-reconfigure openssh-server

  touch /etc/ssh/.generated

  echo "INFO: Copied generated SSH keys to /config"
  # copy generated keys to own directory
  touch /config/.generated
  cp -p /etc/ssh/ssh_host_* /config
fi

# Enable fail2ban, requires rsyslog
if [ "FAIL2BAN" == "yes" ]; then
  echo "INFO: Fail2ban is enabled"
  /etc/init.d/rsyslogd start
  /etc/init.d/fail2ban start
else
  echo "INFO: Fail2ban is disabled"
fi

/usr/sbin/sshd -D

