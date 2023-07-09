
---

# Ansible Environment Setup

.footer: Created By Alex M. Schapelle, VAioLabs.io

---

# Ansible Environment Setup (cont.)

- What do we need ?
  - Physical nodes: if you have 3 physical machines, don't hesitate to use them, else, move to virtual machines
  - Virtual Nodes

> `[!]` Note: We have a `Vagrantfile` to help us to setup our learning environment based on Virtualbox and Vagrant framework, taken from [here](https://gitlab.com/silent-mobius/automation/-/tree/master/IaC/Ansible_Management)

> `[!]` Note: In case, Virtualization and Vagrant are not option, you can try to use docker project from [here](https://gitlab.com/silent-mobius/ansible-compose.git)

---
# Architecture  description

The design goals of Ansible include:

- Minimal in nature. Management systems should not impose additional dependencies on the environment.
- Consistent. With Ansible one should be able to create consistent environments.
- Secure. Ansible does not deploy agents to nodes. Only OpenSSH and Python are required on the managed nodes.
- Reliable. When carefully written, an Ansible playbook can be idempotent, to prevent unexpected side-effects on the managed systems. It is possible to write playbooks that are not idempotent.
- Minimal learning required. Playbooks use an easy and descriptive language based on YAML and Jinja templates.

---

# Architecture  description (cont.)

<img src="../99_misc/.img/ansible_arch.png" alt="our class arch" style="float:right;width:300px;">


- We'll setup our local inventory file that will manage our nodes
- No need to install ansible from system repository
- We'll install it from `pip3`
- Lets call the inventory file: `hosts.ini`
  - `ini` file is a configuration file, computer software that consists of a text-based content with a structure and syntax comprising *_key–value_* pairs for properties
  - yes: it works as `yaml`
  - yes: we can use `yaml` structure instead, but for inventory it is not mandatory

---

# Ansible configuration files

- Install we won't get some of those files for ansible.
- That's why we'll create those files manually.
- This course works on files as if they were `IaC`, thus please manage your code with `version control`.
- Ansible seeks for default config file in your shells current location
  - That's why we'll need to create local config file named `ansible.cfg`
- If Ansible won't find the local `ansible.cfg` file , it will continue to search other default folders such as `/etc` or `/opt`

---
# Static Inventory

Inventory file structure is crucial for Ansible. The structure can be provided as follows:

- [defaults]  
    - [all]
    - [ungrouped]
- [hostnames]
    - ansible_host
- [groups]
    - named-groups
- [host/group_variables]
    - usernames
    - passwords
    - secrets
    - certificates

---

# Practice

- Install all needed packages for ansible to work
- Create automation folder
- Setup version control and save it to remote repository
- Edit `hosts.ini` file
  - Setup groups nodes, web and db
  - Configure variables for all groups
    - User
    - Pass/cert
    - Hostname

---
# Practice (cont.)

```sh
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
# Practice

```ini
[all]
node1
node2
node3
node4

[db]
node1

[web]
node2
```

---
# Dynamic Inventory

- Mostly can be implemented where there is API for managing vm's
  - Cloud
  - Virtual environment

- Why do we need `Dynamic Inventory`, if you already have `Static Inventory` ?

#### And

- If `Dynamic Inventory` exists , What's the point in having `Static Inventory` ?


---

# Dynamic Inventory (cont.)

Dynamic inventories are implemented mainly in environments where 3rd party application can `feed` Ansible with data regarding to hosts on the network. Most of these are `cloud` environments, yet there are custom made applications with `api`, such as cobbler, openstack and so on, that can serve as host inventory provider in closed networks. One may find an [example](https://github.com/lukaspustina/dynamic-inventory-for-ansible-with-openstack/blob/master/openstack_inventory.py) here. 

Also we can find [official documentation](https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html) helping developing scripts , mostly python based, for dynamic inventory generation.

  <!-- - test connection with `ping` module to verify the connection -->

