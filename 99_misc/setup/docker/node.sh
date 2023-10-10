#!/usr/bin/env bash

set -x
. /etc/os-release 

: ${SSH_USERNAME:=user}
: ${SSH_USERPASS:=user}

function create_rundir() {
	mkdir -p /var/run/sshd
}

function create_user() {
    # Create a user to SSH into as.
    useradd -m -s /bin/bash $SSH_USERNAME
    if [[ "$ID" == 'debian' ]];then
        (echo $SSH_USERPASS ;echo $SSH_USERPASS )| passwd  $SSH_USERNAME 
    else
        echo -e "$SSH_USERPASS" | passwd  $SSH_USERNAME --stdin
    fi
    echo ssh user password: $SSH_USERPASS
}

function create_hostkeys() {
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 
}

function copy_ssh_key() {
    if [[ ! -d /home/user/.ssh ]];then
        mkdir -p /home/user/.ssh/
    fi
        cp /root/.ssh/authorized_keys /home/user/.ssh/authorized_keys
        chown 1000:1000 -R /home/user/.ssh
        chmod  600 /home/user/.ssh/authorized_keys
}

function main(){
    create_rundir
    create_hostkeys
    sed -i 's/\#Pubkey/Pubkey/g' /etc/ssh/sshd_config
    create_user
    copy_ssh_key
}

######################
# Call all functions
######################
main 
echo calling $@
exec "$@"
