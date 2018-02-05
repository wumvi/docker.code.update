#!/bin/bash

cd /home/$USER/
mkdir -p sshkey/
mkdir -p .ssh/
ssh-keygen -b 2048 -t rsa -f sshkey/login -q -N ""
RSA_PUB=`cat sshkey/login.pub`

# Запрет ввода любых комманд, кроме указанных
# echo 'command="/run.sh $SSH_ORIGINAL_COMMAND",no-port-forwarding,no-agent-forwarding,no-X11-forwarding,no-pty' $RSA_PUB > .ssh/authorized_keys

chown -R $USER:$USER ./
chmod 0600 sshkey/login
chown root:root sshkey/login