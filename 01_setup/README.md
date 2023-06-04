
---

# Ansible Env Setup

.footer: Created By Alex M. Schapelle, VAioLabs.io

---

# Ansible Env Setup (cont.)

- What do we need ?
  - Physical nodes: if you have 3 physical machines, don't hesitate to use them, else, move to virtual machines
  - Virtual Nodes

> Note: We have a `Vagrantfile` to help us to setup our learning environment based on Virtualbox and Vagrant framework, taken from [here](https://gitlab.com/silent-mobius/automation/-/tree/master/IaC/Ansible_Management)

> Note: in case, Virtualization and Vagrant are not option, you can try to use docker project from [here](https://gitlab.com/silent-mobius/ansible-compose.git)

---

# Ansible Env Setup (cont.)

## Architecture  description

The design goals of Ansible include:

- Minimal in nature. Management systems should not impose additional dependencies on the environment.
- Consistent. With Ansible one should be able to create consistent environments.
- Secure. Ansible does not deploy agents to nodes. Only OpenSSH and Python are required on the managed nodes.
- Reliable. When carefully written, an Ansible playbook can be idempotent, to prevent unexpected side-effects on the managed systems. It is possible to write playbooks that are not idempotent.
- Minimal learning required. Playbooks use an easy and descriptive language based on YAML and Jinja templates.

---
# Ansible Env Setup: Inventory (cont.)


- We'll setup our local inventory file that will manage our nodes
- No need to install ansible from system repository
- We'll install it from `pip3`
- lets call the inventory file: `hosts.ini`
  - `ini` file is a configuration file, computer software that consists of a text-based content with a structure and syntax comprising *_key–value_* pairs for properties
  - yes: it works as `yaml`
  - yes: we can use `yaml` structure instead, but for inventory it is not mandatory

---

## Ansible config files

- Due to `pip3` install we won't get some of those files for ansible.
- That's why we'll create those files manually.
- This course works on files as if they were `IaC`, thus please manage your code with `version control`.
- Ansible seeks for default config file in your shells current location
  - That's why we'll need to create local config file named `ansible.cfg`
- If Ansible won't find the local `ansible.cfg` file , it will continue to search other default folders such as `/etc` or `/opt`

---
# Ansible Env Setup (cont.)
## Static Inventory

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

# Ansible Env Setup (cont.)

## Dynamic Inventory

- Mostly can be implemented where there is API for managing vm's
  - Cloud
  - Virtual environment

## Why do we need `Dynamic Inventory`, if you already have `Static Inventory` ?
## And
## If `Dynamic Inventory` exists , What's the point in having `Static Inventory` ?

Dynamic inventories are implemented mainly in environments where 3rd party application can `feed` Ansible with data regarding to hosts on the network. Most of these are cloud environments, yet there are custom made applications with api that can serve as host inventory provider in closed networks. There are also specific hardware that can provide with same capability.

---

# Lab

- Install all needed packages for ansible to work
- Create automation folder
- Setup version control and save it to remote repository
- Create `hosts.ini` file
  - Setup groups nodes, web and db
  - Configure variables for all groups
    - User
    - Pass/cert
    - Hostname
  <!-- - test connection with `ping` module to verify the connection -->

