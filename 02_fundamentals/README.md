
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

Ansible allows admins to run ad-hoc commands on one or hundreds of machines at the same time, using the `ansible` command

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

# Ansible configuration file

Although somewhat straight forward, but all the Ansible main configurations, can be found under file named `ansible.cfg`. The thing is that file can be found in different places:
- `/etc/ansible/ansible.cfg`: in case Ansible was install with OS's package manager, for example `apt-get` or `dnf`
- `/home/$USER/.local/share/ansible/ansible.cfg`: in case Ansible was installed with pip/pipx

That configuration file will hold the default configurations of the Ansible.

#### What if I prefer to use version control on my Ansible ?

- Great question:
    - Ansible seeks for the configuration file recursively, meaning it has map of locations where it searches for the file named `ansible.cfg`
    - The folder it starts to search for the `ansible.cfg` file, start from the current invocation folder.
    - If `ansible.cfg` is not found will go back, on folder to check if the file is there, if not, it will `cd` another folder back, until the file is found.
    - If not found, it will check the above mentioned `map` to check existing configurations.
    - IF STILL NOT FOUND: then you are probably on wrong host but better **ask instructor** for help.

---

# Practice

- Connect to remote host with user `user` and become root user with sudo
- Use module named `command` to see the output of `/etc/os-release` file on all hosts

```ini
[multi:var]
username=user
password=docker
```

```sh
ansible all -m command -a 'cat /etc/os-release'
```
---

# Ansible modules

- When ever we wish to use Ansible capabilities, we'd prefer to do it with module designated for that.

- Here is a list of 100 most used modules: [check it out](https://mike42.me/blog/2019-01-the-top-100-ansible-modules)
  - No : We are not gonna learn them all.
  - Yes: We'll go through most of them.

> `[!]` Note: Ansible project has been disassembled due to its massive size and currently the modules that we are covering are called `builtin` modules.
> `[!]` Note: Additional modules can be found under official documentation: `https://docs.ansible.com` and also at ansible galaxy repository: `https://galaxy.ansible.com`


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
    - Arguments: gather_subset=<SUBSET_GROUP\>  filter=<FILTERED_VALUE\>
- Module: debug
    - Purpose: Print statements during execution.
    - Arguments: msg=<THE_CUSTOME_MESSAGE\> var=<A_VAR_NAME_TO_DEBULG\>

---

# Ansible modules (cont.)

- Module: apt
    - Purpose: Install software with apt.
    - Arguments: name=<PACKAGE_NAME\> state=<STATE\>
- Module: dnf/yum
    - Purpose: Install software with apt.
    - Arguments: name=<PACKAGE_NAME\> state=<STATE\>
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
- Module: service
    - Purpose: Control service daemons.
    - Arguments: name=<SERVICE_NAME> state=<STATE\>
- Module: systemd
    - Purpose: Controls systemd units (services, timers, and so on) on remote hosts.
    - Arguments: name=<SERVICE\> state=<EXPECTED_STATUS\>
- Module: git
    - Purpose: Manage git checkouts of repositories to deploy files or software.
    - Arguments: repo:<GIT_REPO_URL\> dest:<PATH\>

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
