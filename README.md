SSH Server
========

This image allow to run a sshd instance to allow simple SSH access to an Linux system and can be used as stepping stone. It is also possible to enable fail2ban to block failed login attempts.

Volumes
-------

`/config`

Run
---

Launch the SSH Server docker container with the following command:

```
docker run [-d] \
    --name=ssh \
    -p 10022:22 \
    -e USERNAME="alex" \
    -e USERPASSWORD="alex" \
    -e USERSUDO="yes" \
    -e ROOTPASSWORD=donotknow \
    -e ROOTLOGIN="no" \
    -e FAIL2BAN="yes" \
    -v /docker/ssh:/config \
    ualex73/docker-sshd
```

Where:
  - `USERNAME`: The user's username.
  - `USERPASSWORD`: The user's password.
  - `USERSUDO`: If the user is allowed to use 'sudo'.
  - `ROOTPASSWORD`: The 'root' password. If not specified, it will use a random password. This password is in the docker logfile.
  - `ROOTLOGIN`: If 'root' is allowed to login.
  - `FAIL2BAN`: Enable fail2ban to block failed login attempts.
  - `/docker/ssh`: This is where the persistent SSH keys are stored.
  - `22`: SSH Server port.

Docker-compose.yaml Example
---
```
version: '3'

services:

 ssh:
    container_name: ssh
    image:  ualex73/docker-sshd
    restart: unless-stopped
    ports:
      - 10022:22
    environment:
      - USERNAME="alex"
      - USERPASSWORD="alex"
      – USERSUDO="yes"
      – ROOTPASSWORD=donotknow
      - ROOTLOGIN="no"
    volumes:
      - /docker/ssh:/config
```

