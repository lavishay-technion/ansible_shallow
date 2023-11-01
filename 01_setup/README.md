
---

# Ansible Environment Setup

.footer: Created By Alex M. Schapelle, VAioLabs.io

---

# Ansible Environment Setup 

As mentioned, we will be working on our virtual labs with docker, thus docker installation is required.
- What do we need ?
  - Unix/Linux Node
  - Docker environment installed
  - Text editor: I'll be using `vim`, yet your are welcome to use anything you wish and are comfortable with.

- To install docker and docker compose run on Debian based Linux distributions: 

```sh
curl -L get.docker.com| sudo bash
```
  - In case you are using RedHat based Linux distro, like Fedora, Rocky and Alma, the above command should work in same manner.
  - With RedHat itself, it will require you to use license which you need to purchase
  - while with Windows, Please install Docker-Desktop.
  - In case of MacOS, Docker-Desktop is the latest .

> `[!]` Note: I, myself am using Linux distribution, in case you use something else, there should not be too much of the difference, yet that is the price of learning: adaptation to the unknown.

> `[!]` Note: You should try to use docker project from [here](https://gitlab.com/silent-mobius/ansible-compose.git)

---

# Architecture  description

The design goals of Ansible include:

- __Minimal in nature__: Management systems should not impose additional dependencies on the environment.
    - That said if you are implementing Ansible from the begining, it requires ssh/ssh-keys
- __Consistent__: With Ansible one should be able to create consistent environments.
- __Secure__: Ansible does not deploy agents to nodes. Only OpenSSH and Python are required on the managed nodes.
- __Reliable__: When carefully written, an Ansible playbook can be idempotent, to prevent unexpected side-effects on the managed systems. It is possible to write playbooks that are not idempotent.
- __Minimal learning required__: Playbooks use an easy and descriptive language based on YAML and Jinja templates.

---

# Architecture  description (cont.)

Generally the Ansible architecture should look like this, yet in some examples it might differ.

<img src="../99_misc/.img/ansible_arch.png" alt="our class arch" style="float:right;width:400px;">

But in order to make it work, we'll need existing software packages, modules and configuration files to work on.
When we issue `ansible --version` command it will provide us with information about ansible referencing the configuration files.
<br>
<br>
<br>
<br>
<br>

```sh
ansible --version
ansible [core 2.14.3]
  config file = None
  configured module search path = ['/home/aschapelle/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/aschapelle/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.11.2
```
> `[!]` Note: `config file = None` that is reference to main ansible configuration is set to `None`, thus it gives us possibility to learn to build the file from scratch.

---

# Ansible configuration file

We initially suggested that there are no default config files with Ansible, yet Ansible still requires to have one. Ansible seeks that file in various places with multiple locations based on the installation method, and the search has precedence within our working system.
The locations ansible will search for config file from the highest to lowest precedence are:
<!-- Show example from 4 to 1 -->
1. `ANSIBLE_CONFIG`: Environment variable with filename 
2. `./ansible.cfg`: An Ansible config file in current directory
3. `~/.ansible.cfg`: Hidden file in your users hoime directory.
4. `/etc/ansible/ansible.cfg`: Typically provided, through package manager of our system.

- This course works on files as if they were `Infra-As-a-Code` or `IaC`, thus the most usable way for us to use `git` with Ansible config file would be option 2.
- Ansible seeks for default config file in your shells current location
  - That's why we'll need to create local config file named `ansible.cfg`
- If Ansible won't find the local `ansible.cfg` file , it will not work so,

---

# Inventories

Lets take a look on inventories, their types and uses on different types of Linux hosts, inventory variables, ranges, groups and group children 
However, before diving into these, One thing we must always consider. to work with our tools at hand: As mentioned, Ansible has several configuration files, and all these need to be maintained, updates, developed and saved on remote place.
In this course we'll be using `git` version control and `gitlab` remote server to work on the contents of Ansible files. As such the student working on their own device, will need to install git client on their working device and also create/use `gitlab/github/any remote git based repository` to follow the course.

In order to start, well work in structured manner, of creating designated folders with chapter naming and under each chapter we'll practice subject at hand.
This chapter follows `setup` topic thus we should create folder named in the same manner in continue by using sub-folder for each sub-topic.E.g.
```sh
mkdir -p 01_setup/{00_ansible_cfg,01_inventories}
```

### Static Inventories

Inventory file structure is crucial for Ansible. You can create your inventory file in one of many formats, depending on the inventory plugins you have. The most common formats are `INI` and `YAML`
- An `.ini` file is a configuration file for computer software that consists of a text-based content with a structure and syntax comprising **key–value** pairs for properties, and sections that organize the properties
- The `hosts.ini` file can also be written in `yaml` format, with `.yml` extension, yet it is not mandatory.

The structure can be provided as follows:
- defaults :Even if you do not define any groups in your inventory file, Ansible creates two default groups:
    - `[all]` : group contains every host
    - `[ungrouped]` : all hosts that don’t have another group aside from all

> `[!]` Note: Every host will always belong to at least 2 groups: `all` and `ungrouped` or `all` and some other group

- `[groups]`: Any name in square brackets is considered as custom group
    - Any hostname or ip address, under group name will be considered as part of a group
    - Each host can be in several groups at the same time.
    - Groups can have parent/child relationships.Parent groups are also known as nested groups or groups of groups.
        - To create parent/child relationships for groups in INI format, use the `:children` suffix

---

# What now ?

- We'll setup our configuration and local inventory files that will manage our nodes
    - In virtual labs, there is no need to install Ansible, because it is installed already
    - We can install Ansible from `pip3` to use the latest version.
        - In python3.11 `pipx` is the tool required to do so and it also requires virtual-environments either with `venv`, `pipenv` or `poetry`
- Also we'll connect to all virtual nodes (containers)
- In addition, we will create version control to  manage our changes
- Finally we'll start using Ansible command line utility to learn its capabilities

In other words: lets go and practice

---

# Practice

- `cd` to 99_misc/setup/docker
- Execute `docker compose up -d` command to setup environment
- Log in to Ansible host container with : 
    - `docker compose exec -it ansible-host /bin/bash`
    - You'll be logged as `root` user, something that is not production environment possible, but should be fine in Lab environment
- Install all needed packages for Ansible to work
- Create automation folder `/ansible`
- Setup version control and save it to remote repository
- Edit `hosts.ini` file
  - Setup groups all, web and db
  - issue an `ansible --list-host all`
    - if there is suitable output kill the lab, by exiting the ansible-host container and stopping docker compose with `docker compose down` command

---

# Practice (cont.)

```sh
cd 99_misc/setup/docker
docker compose exec -it ansible-host /bin/bash
apt update && apt install ansible -y
mkdir automation && cd automation
touch README.md .gitignore ansible.cfg hosts.ini
git init 
git config user.name silent-mobius
git config user.mail alex@vaiolabs.com
git add .
git commit -m "initial commit to repo"
git remote add remote-repo-url
git push -U origin master
vi hosts.ini
```
---

# Practice (cont.)

```ini
[defaults]
inventory = hosts.ini
```

```ini
[all]
node1
node2

[db]
node1

[web]
node2
```

```sh
ansible --list-hosts all
# if there is output
exit
docker compose down
```


---

# Hosts, Groups and Variables

The `hosts.ini` file enables us to create structured **key value** pairs, that eventually will be our targets on to which we would like to execute some type of command.
In previous practice we did setup up groups but did not emphasized the explanations, thus lets fix that:
lets start the lab again the edit additional configurations that we could have 
```sh
cd 99_misc/setup/docker
docker compose up -d
docker exec -it ansible-host /bin/bash 
mkdir ansible && cd ansible
touch hosts.ini ansible.cfg
```
Once we are inside and have initial building block lets start updating files step by step to learn more:

- Lets check connectivity between `ansible-host` and `node1`
```sh
ping node1
```
- Configure which default inventory file should we use: 

```sh
vi ansible.cfg
```
```ini
[defaults]
inventory = hosts.ini
```

- When running systems it is good idea to separate them in to logical groups, so we should create  groups in `hosts.ini`
  
```sh
vi hosts.ini
```
```ini
[all]
node1
node2
node3
node4
node5
node6

[web]
node2
node4
[db]
node1
node3
[monitor]
node5
node6

[multi:children]
web
db
```
> `[!]` Note: for purposes of the exercise these nodes do not exists. We are just providing examples of possible environments.

Lets check what we have:

```sh
ansible --list-hosts web
ansible --list-hosts db
ansible --list-hosts all
```
---

# Hosts, Groups and Variables (cont.)

When using Ansible, it will try to connect via ssh service, which in return requires digital fingerprint writing to `known_hosts` as well as ssh certificates, private and public.
The issue with digital fingerprints, are that in some cases we just want to check connectivity and to by pass that we can use custom Ansible environment variables as in any other UNIX/Linux command.

```sh
ANSIBLE_HOST_KEY_CHECKING=False  ansible  all -m ping
```

While it is somewhat convenient to use environment variables, it is always useful to set these setting in to configuration files. In this case almost all environment variables can be set into `ansible.cfg` file. 

```sh
vi ansible.cfg
```
```ini
[defaults]
inventory = hosts.ini
host_key_checking = False
```

---

# Hosts, Groups and Variables (cont.)

Each host in the `ini` file can have itself configured with Ansible variables for different purposes:
- `ansible_user`: The user name to use when connecting to the host
- `ansible_host`: The name of the host to connect to, if different from the alias you wish to give to it.
- `ansible_password`: The password to use to authenticate to the host (never store this variable in plain text)
- `ansible_ssh_private_key_file`: Private key file used by ssh. Useful if using multiple keys and you don’t want to use SSH agent
- `ansible_become`: Equivalent to `ansible_sudo` or `ansible_su`, allows to force privilege escalation
- `ansible_become_method`: Allows to set privilege escalation method
- `ansible_become_password`: Equivalent to ansible_sudo_password or ansible_su_password, allows you to set the privilege escalation password

Are there more variables? yes, definitely but, we'll NOT gonna cover it all.

```sh
vi hosts.ini
```
```ini
[all]
node1 ansible_user=user ansible_password=docker
```
Let's test our configuration with modules. We'll cover them later in depth, but for now let's use `ping` and `command` modules.
```sh
ansible all -m ping -o
ansible all -m command -a 'id' -o
```
When using `ping` module, we should get json output, with value `pong`. If no value comes or there are errors, it means something is wrong and we must fix it.
When using `command`, we are asking Ansible to run a `specific command` on remote hosts. The `specific command` is passed as an argument to `command` module. If we get output of the command passed as an argument, then it worked, yet if we did not get the command output, we need to fix the configuration.

---

# Practice

- Add to existing node1 and node3 user `root` and password `docker`
- Test connection with command `id` and verify that user providing the answer is `root`

```ini
[db]
node1   ansible_user=root   ansible_password=docker
node3   ansible_user=root   ansible_password=docker
```
```sh
ansible all -m command -a 'id' -o
```
---

# Hosts, Groups and Variables (cont.)

As seen in our first example, we can chain groups of hosts and also we can chain group of groups as `children` groups. In previous we saw that we can add to each host its own Ansible variable, but one must agree that there should be better way to do so, we can setup group variables.

```ini
[multi:children]
web
db

[multi:vars]
ansible_user = root
ansible_password = docker
```
---

# Practice

- Remove db group nodes variables
- Add to existing inventory multi-group variables of `ansible_user` and `ansible_ssh_private_key`
- Test the variables with `id` command.
    - If there are any errors, act accordingly to fix them.

```ini
[multi:vars]
ansible_user = root
ansible_ssh_private_key_file = ./id_rsa
```

```sh
chmod 600 id_rsa
ansible all -m command -a 'id' -o
```


---

# Dynamic Inventories

Mostly can be implemented where there is API for managing vm's
- Cloud
- Virtual environment

Why do we need `Dynamic Inventory`, if you already have `Static Inventory` ?

#### And

If `Dynamic Inventory` exists , What's the point in having `Static Inventory` ?


---

# Dynamic Inventory (cont.)

Dynamic inventories are implemented mainly in environments where 3rd party application can `feed` Ansible with data regarding to hosts on the network. Most of these are `cloud` environments, yet there are custom made applications with `api`, such as cobbler, openstack and so on, that can serve as host inventory provider in closed networks. One may find an [example](https://github.com/lukaspustina/dynamic-inventory-for-ansible-with-openstack/blob/master/openstack_inventory.py) here. 

Also we can find [official documentation](https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html) helping developing scripts , mostly python based, for dynamic inventory generation.

  <!-- - test connection with `ping` module to verify the connection -->

> `[!]` Note: We'll talk about Dynamic inventories later during the course.


