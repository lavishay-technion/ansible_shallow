
--- 

# Ansible Ad-Hoc Commands

.footer: Created By Alex M. Schapelle, VAioLabs.io

---
# Ansible Ad-Hoc Commands

## Ansible command

```sh
ansible <HOST> -b -m <MODULE> -a "<ARG1 ARG2 ARG_N>" -f <NUM_FORKS>
```
- `-b`: request for ansible to become root user on remote host
- `-m`: ask ansible to use specific module (as mentioned the default is `command`)
- `-a`: pass a argument to module
- `-f`: run ansible in parallel with all
- `-i`: use specific inventory and not the default.
- `-e`: pass extra variable of your choice

- Runs Ansible executable according to its `inventory` file.
- Ansible runs ad-hoc commands
    - Ad-Hoc commands are basic commands used by Ansible
    - `Commands` essentially are python written code to behave as simple system call.
    - By default it is running with `command` ad-hoc module
---
# Ansible Ad-Hoc Commands

## Ansible modules

- When ever we wish to use Ansible capabilities, we'd prefer to do it with module designated for that.

- Here is a list of 100 most used modules: [check it out](https://mike42.me/blog/2019-01-the-top-100-ansible-modules)
  - No : We are not gonna learn them all.
  - Yes: We'll go through most of them.

---

# Ansible modules (cont.)
- Module: command
    - Purpose: The `command` module takes the command name followed by a list of space-delimited arguments.The given command will be executed on all selected nodes.
    - Arguments: chdir=<PATH\> cmd=<COMMAND_TO_RUN\> creates=<PATH\> removes=<PATH\>
- Module: file
    - Purpose: Set attributes of files, symlinks or directories.Also, remove files, symlinks or directories.
    - Arguments: path=<PATH\> mode=<PERMISSIONS\>
- Module: ping
    - Purpose: Verify Ansible connectivity between hosts.
    - Arguments: None
- Module: setup
    - Purpose: Collect Ansible facts.
    - Arguments: None
- Module: yum
    - Purpose: Install software with yum.
    - Arguments: name=<PACKAGE_NAME\> state=<STATE\>
---

# Ansible modules (cont.)

- Module: apt
    - Purpose: Install software with apt.
    - Arguments: name=<PACKAGE_NAME\> state=<STATE\>
- Module: service
    - Purpose: Control service daemons.
    - Arguments: name=<SERVICE_NAME> state=<STATE\>
- Module: copy
    - Purpose: Copy a file to a particular location on a target host.
    - Arguments: src=<SOURCE_PATH\> dest=<ABSOLUTE_DESTINATION_PATH\>
- Module: get_url
    - Purpose: Downloads files from HTTP, HTTPS, or FTP to the remote server
    - Arguments: url=<URL\> dest=<PATH\>
- Module: lineinfile
    - Purpose: Ensures a particular line is in a file, or replace an existing line using a back-referenced regular expression
    - Arguments: path=<PATH\> line=<LINE_TO_ADD\> regex=<REGEX_TO_MATCH\>
- Module: archives
    - Purpose: Creates or extends an archive
    - Arguments: path=<PATH\> dest=<PATH\>
---

# Ansible modules (cont.)

- Module: user
    - Purpose: Manage user accounts and user attributes
    - Arguments:   name=<USERNAME\> comment=<DESCRIPTION\> uid=<UID\> group=<GROUPNAME\>
- Module: systemd
    - Purpose: Controls systemd units (services, timers, and so on) on remote hosts.
    - Arguments: name=<SERVICE\> state=<EXPECTED_STATUS\>
- Module: git
    - Purpose: Manage git checkouts of repositories to deploy files or software.
    - Arguments: repo:<GIT_REPO_URL\> dest:<PATH\>

---

# Lab

- Run ansible command to with needed module to:
  - List all hosts in inventory file.
  - Ping web group in hosts list.
  - Get ip address of all remote hosts.
  - Install: unrar, sshagent, python3 and htop.
  - Verify that user (vagrant or any other specific) exists in system.
  - Get information regarding rpm based host.
  - Check if httpd service is running on all hosts.
  - Download git source code, unzip it and compile it on all hosts (requires several modules and commands).
  - Set kernel parameter of `net.ipv4.conf.all.accept_redirects` to 1 at /etc/sysctl.conf (it will need to be uncommented).
  - Check what is the storage capacity on all hosts.


