#!/usr/bin/env bash

: ${SSH_USERNAME:=user}
: ${SSH_USERPASS:=$(dd if=/dev/urandom bs=1 count=15 | base64)}

function create_rundir() {
	mkdir -p /var/run/sshd
}

function create_user() {
# Create a user to SSH into as.
useradd $SSH_USERNAME
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin $SSH_USERNAME)
echo ssh user password: $SSH_USERPASS
}

function create_hostkeys() {
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 
}

function main(){
    create_rundir
    create_hostkeys
    sed -i 's/\#Pubkey/Pubkey/g' /etc/ssh/sshd_config 
    create_user
}

######################
# Call all functions
######################
main 
echo calling $@
exec "$@"
