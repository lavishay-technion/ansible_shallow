
--- 

# Ansible Ad-Hoc Commands

.footer: Created By Alex M. Schapelle, VAioLabs.io

---

# Ansible Ad-Hoc Commands

Let us explore how Ansible helps you quickly perform common tasks on, and gather data from, one or many servers with **ad-hoc** commands. The number of servers managed by an individual administrator has risen dramatically in the past decade, especially as virtualization and growing cloud application usage has become standard fare. As a result, admins have had to find new ways of
managing servers in a streamlined fashion.
On any given day, a systems administrator has many tasks:

- Apply patches and updates via dnf, apt, and other package managers.
- Monitor resource usage (disk space, memory, CPU, swap space, network).
- Manage system users and groups.
- Deploy applications or run application maintenance.
- And so on ...

Ansible allows admins to run ad-hoc commands on one or hundreds of machines at the same time, using the `ansible` command.


---


# Ansible command

```sh
ansible <HOST> -b -m <MODULE> -a "<ARG1 ARG2 ARG_N>" -f <NUM_FORKS>
```
- `-b`: request for Ansible to become root user on remote host
- `-m`: ask Ansible to use specific module (as mentioned the default is `command`)
- `-a`: pass a argument to module
- `-f`: run Ansible in parallel with all
- `-i`: use specific inventory and not the default.
- `-e`: pass extra variable of your choice

- We run Ansible executable according to its commands parameters with `inventory` file hosts.
- Ansible runs ad-hoc commands
    - Ad-Hoc commands are basic commands used by Ansible
    - `Commands` essentially are python written code to behave as simple system call.
    - By default, if no Ansible command/module is provided, it will run with `command` ad-hoc module

---

# Practice

- Connect to remote host with user `docker` and become root user with sudo
- Use module named `command` to see the output of `/etc/os-release` file on all hosts

```ini
[multi:var]
username=user
password=docker
```

```sh
ansible all -m command -a 'cat /etc/os-release' -u docker
```
---

# Idempotency

An operation is idempotent, if the result of performing it once, is exactly the same as the result of performing it repeatedly without any intervening actions.
As such when we use `ansible` , it tries to notify as if the action we performed was idempotent or not, by coloring the output with 3 rather intuative colors:

- Green : Success, no changes have been done.
- Yellow : Succes, changes performed were successful.
- Red : Failure

---

# Ansible Modules and Plugins

#### What is the difference ?

<img src="../99_misc/.img/modules.png" alt="our class arch" style="float:right;width:200px;">

- Plugins extend Ansible’s core functionality. Most plugin types execute on the control node within the `/usr/bin/ansible` process.
- Modules, are discrete units of code that can be used from the command line or in a playbook task. Ansible executes each module, usually on the remote target node, and collects return values. Modules are the main building blocks of Ansible playbooks. Although we do not generally speak of “module plugins”, a module is a type of plugin.
A lot of times Ansible is addressed as `batteries included framework`. and the reason is the vast list of modules that we can use.


- Here is a list of 100 most used modules: [check it out](https://mike42.me/blog/2019-01-the-top-100-ansible-modules)
  - No : We are not gonna learn them all.
  - Yes: We'll go through a lot of them.

> `[!]` Note: Ansible project has been disassembled due to its massive size and currently the modules that we are covering are called `builtin` modules.

> `[!]` Note: Additional modules can be found under official documentation: `https://docs.ansible.com` and also at ansible galaxy repository: `https://galaxy.ansible.com`


---

# Ansible Modules (cont.)

#### `Setup` Module
Let us begin with module named `setup`:

- Purpose: Collect Ansible fact
- Arguments: gather_subset=<SUBSET_GROUP\> filter=<FILTERED_VALUE\>
- This module is automatically executed, when playbooks are used, to gather info as variable, about remote targets
- It can be executed manually to find out variable on available hosts
    - Variables/information received are called `facts`
- `setup` is supported on all platforms with remote access (ssh/winrm)
- [Please see the docs](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/setup_module.html)
---

# Practice

- Create folder 02_fundamentals/modules/setup
- `cd` into it
- Ping node1 and node2
- Verify in inventory that nodes above are defined
- Use `setup` module to get facts from node1 and node2 one after another
- Try to filter out the node1/2 ip address with `filter` attribute
- Save the commands in cmd_line.txt file and back it up with git version control

```sh
mkdir -p 02_fundamentals/modules/setup && cd 02_fundamentals/modules/setup
ping -c 1 node1
ping -c 1 node2
ansible --list-host all
ansible node1 -m setup -a "filter=ansible_distribution"
ansible node2 -m setup -a "filter=ansible_distribution"
echo !!  >> cmd_line.txt

```

---

# Ansible Modules (cont.)

#### `File` Module

- Sets attributes of files, symlink and directories, or removes them.
- Many other modules support the same options as the `file` module, including `copy`, `template` and `assemble`
    - For Windows targets, use the `win_file` module instead 
- Ansible project on github has moved the file module to be part of ansible-base and classed as a builtin plugin. This only effects the way we would like to invoke the `file` module
    - `file`
    - `anisble.builtin.file`
- Module can be used with various `states`, meaning we can require it to perform most of the operations on files as we do on any *nix based system:
    - `absent`
    - `touch`
    - `directory`
    - `link`
    - `hard`
- Every action with `file` module can be accompnied with mode of permissions like in any other *nix system
- [Please see the docs](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html)

---

# Practice

- Create folder 02_fundamentals/modules/File and move into it.
- Execute module file while creating file named `test` at `/tmp` path on all the nodes
- Use file module to create empty folder `config` at `/opt` folder
- Change the `test` file permission to be read and written by user only
- save all commands in to cmd_line.txt and save it on git versino control

```sh
mkdir -p 02_fundamentals/modules/File && cd 02_fundamentals/modules/File
ansible all -m file -a 'path=/tmp/test state=touch'
ansible all -m file -a 'path=/opt/config state=directory'
ansible all -m file -a 'path=/tmp/test state=touch mode=600'

```

---

# `Copy` Module

- The `copy` module copies a file from the local or remote target, to a location on the remote target. The reverse action can be accomplished with `fetch` module.
    - from source to destination
- If we need to use it in scripting, it is suggested to use `template` module.
- For windows we use `win_copy` module instead
- Most of other options from `file` module are also applicable onto this module as well
- [Please see the docs](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html)



---

# Practice

- Create folder 02_fundamentals/modules/copy and move into it.
- Create a file named `conf_web.yml` and write in it name of web server with the path to `index.html`.
    - In case of nginx -> `/usr/share/nginx/html/index.html`
- Use `copy` module to copy `conf_web.yml` file to `/opt` on web servers
- Create a file named `conf_db.yml`  and write in it name of db server with path to its configuration file
    - In case of postgresql15 -> `/etc/postgresql/15/main/postgresql.conf`
- Use `copy` module to copy `conf_db.yml` file to `/opt` on web servers

```sh
mkdir -p 02_fundamentals/modules/copy && cd 02_fundamentals/modules/copy
touch conf_web.yml conf_db.yml
echo 'nginx: /usr/share/nginx/html/index.html' > conf_web.yml
echo 'postgresql15: /etc/postgresql/15/main/postgresql.conf' >conf_db.yml
ansible web -m copy -a 'src=./conf_web.yml dest='
```
 

<!--
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
    - Arguments: gather_subset=<SUBSET_GROUP\>  filter=<FILTERED_VALUE\>

---

# Ansible modules (cont.)

- Module: debug
    - Purpose: Print statements during execution.
    - Arguments: msg=<THE_CUSTOME_MESSAGE\> var=<A_VAR_NAME_TO_DEBULG\>
- Module: apt
    - Purpose: Install software with apt.
    - Arguments: name=<PACKAGE_NAME\> state=<STATE\>
- Module: dnf/yum
    - Purpose: Install software with apt.
    - Arguments: name=<PACKAGE_NAME\> state=<STATE\>
---

# Ansible modules (cont.)

- Module: copy
    - Purpose: Copy a file to a particular location on a target host.
    - Arguments: src=<SOURCE_PATH\> dest=<ABSOLUTE_DESTINATION_PATH\>
- Module: get_url
    - Purpose: Downloads files from HTTP, HTTPS, or FTP to the remote server
    - Arguments: url=<URL\> dest=<PATH\>
- Module: lineinfile
    - Purpose: Ensures a particular line is in a file, or replace an existing line using a back-referenced regular expression
    - Arguments: path=<PATH\> line=<LINE_TO_ADD\> regex=<REGEX_TO_MATCH\>

---

# Ansible modules (cont.)

- Module: archives
    - Purpose: Creates or extends an archive
    - Arguments: path=<PATH\> dest=<PATH\>
- Module: user
    - Purpose: Manage user accounts and user attributes
    - Arguments:   name=<USERNAME\> comment=<DESCRIPTION\> uid=<UID\> group=<GROUPNAME\>
- Module: service
    - Purpose: Control service daemons.
    - Arguments: name=<SERVICE_NAME> state=<STATE\>
- Module: systemd
    - Purpose: Controls systemd units (services, timers, and so on) on remote hosts.
    - Arguments: name=<SERVICE\> state=<EXPECTED_STATUS\>
- Module: git
    - Purpose: Manage git checkouts of repositories to deploy files or software.
    - Arguments: repo:<GIT_REPO_URL\> dest:<PATH\>
-->
---

# Practice

- Run Ansible command to with needed module to:
  - List all hosts in inventory file.
  - Ping web group in hosts list.
  - Get environment variables of all remote hosts.
  - Get package manager of all remote hosts.
  - Install: git, unrar, ssh-agent/sshpass, python3 and htop on all hosts. (on redhat based system ssh-agent is as same as sshpass)
  - Verify that user (user, vagrant or any other specific) exists in system.
  - Install web server on web group hosts.
  - Install db  server on db group hosts.
  - Check if web service is running on web host group.(apache2 or nginx)
  - Check if db service is running on db host group.(mysql or postgresql)
  - Set kernel parameter of `net.ipv4.conf.all.accept_redirects` to 1 at /etc/sysctl.conf (it will need to be uncommented).
  - Check what is the storage capacity on all hosts.

---

# Practice (cont.)

```sh

ansible --list-hosts all
ansible -m ping web
ansible -m setup -a 'filter=ansible_env' all
ansible -m setup -a 'filter=ansible_pkg_mgr' all
ansible -m apt -a 'name=git,unrar,sshpass,python3,htop' all
ansible -m apt -a 'name=nginx' web
ansible -m apt -a 'name=mysql' db
ansible -m setup -a 'filter=*user*' all
ansible -m command -a 'grep user /etc/passwd'
ansible -m systemd -a 
```

