# Git Shallow Dive



.footer: Created By Alex M. Schapelle, VAioLabs.io


---
# Who is this for ?

- The name kind of mentions it:
    - System administrators who wish to learn basic git usage.
    - SysOps who are moving to DevOps jobs.
- But it also can be useful for:
    - Junior DevOps who wish to gain minimal knowledge of git version control.
    - Junior software developers who have no knowledge in regards version control.

---

# Prerequisites

- Basic understanding of POSIX shell (Sh, Bash, Zsh, Fish).
- Shell command install.
- Minimal understanding of filesystem.
- Some **Programming** or **Scripting** experience can be useful



---

# Course Topics

- [Setup](../01_setup/README.md)
- [Fundamentals](../02_fundamentals/README.md)
- [Yaml Basics](../03_yaml_basics/README.md)
- [Playbooks](../04_playbooks/README.md)
- [Advance Execution](../05_advance_execution/README.md)
- [Roles](../06_roles/README.md)
- [Troubleshooting](../07_troubleshooting/README.md)

---
# About Me

<img src="../99_misc/.img/me.jpg" alt="drawing" style="float:right;width:180px;">

- Over 12 years of IT industry Experience.
- Fell in love with AS-400 unix system at IDF.
- 5 times tried to finish degree in computer science field
    - Between each semester, I tried to take IT course at various places.
        -  A+.
        -  Cisco CCNA.
        -  RedHat RHCSA.
        -  LPIC1 and Shell scripting.
        -  Other stuff I've learned alone.

---

# About Me (cont.)
- Over 7 years of sysadmin:
    - Shell scripting fanatic
    - Python developer
    - JS admirer
    - Golang fallen
    - Rust fan
- 5 years of working with devops
    - Git supporter
    - Vagrant enthusiast
    - Ansible consultant
    - Container believer
    - K8s user

---
# About Me (cont.)

You can find me on the internet in bunch of places:

- Linkedin: [Alex M. Schapelle](https://www.linkedin.com/in/alex-schapelle)
- Gitlab: [Silent-Mobius](https://gitlab.com/silent-mobius)
- Github: [Zero-Pytagoras](https://github.com/zero-pytagoras)
- ASchapelle: [My Site](https://aschapelle.com)
- VaioLabs-IO: [My company site](https://vaiolabs.io)


---
# About You

Share some things about yourself:

- Name and surname
- Job description
- What type of education do you poses ? formal/informal/self-taught/university/cert-course
- Do you know any of those technologies below ? What level ?
    - Docker / Docker-Compose / K8s
    - Jenkins
    - Git / GitLab / Github / Gitea / Bitbucket
    - Bash Script
    - Python3 / Pytest / Pylint / Flask
    - Ansible / Terraform
- Do you have any hobbies ?
- Do you pledge your alliance to [Emperor of Man kind](https://warhammer40k.fandom.com/wiki/Emperor_of_Mankind) ?



---


# History

The term "ansible" was coined by Ursula K. Le Guin in her 1966 novel Rocannon's World, and refers to fictional `instantaneous communication systems`.
The Ansible tool was developed by Michael DeHaan, the author of the provisioning server application Cobbler and co-author of the Fedora Unified Network Controller (Func) framework for remote administration.
Ansible, Inc. (originally AnsibleWorks, Inc.) was the company founded in 2013 by Michael DeHaan, Timothy Gerla, and Saïd Ziouani to commercially support and sponsor Ansible. Red Hat acquired Ansible in October 2015.
Ansible is included as part of the Fedora distribution of Linux, owned by Red Hat, and is also available for Red Hat Enterprise Linux, CentOS, openSUSE, SUSE Linux Enterprise, Debian, Ubuntu, Scientific Linux, and Oracle Linux via Extra Packages for Enterprise Linux (EPEL), as well as for other operating systems

---

## What is Ansible?
Ansible is an open-source software provisioning, configuration management, and application-deployment tool enabling infrastructure as code.

## Why we need it?

Lets assume that you have a couple of remote instances running some services. Due to some issue or upgrade in those services you might need to alter the configurations in those remote instances. What you would have to do is make those changes in each of those instances manually. The importance of a configuration management system comes in handy in a situation like this. Do the configuration changes in a master instance and it will make sure that all other instances would have the proper changes. Ansible is a such configuration management tool. Ansible connects with its other instances using SSH. Therefore there is no concept such as an agent when using Ansible

---
# Ansible (cont.)


## Why not scripts: Bash/Python/Ruby/JavaScript/Go

- Lets discuss

---
# What are pre requisites ?

Ansible requires Python to be installed on all `managing` machines, including pip package manager along with configuration-management software and its dependent packages. 
Managed network devices require no extra dependencies and are agent less. We can sum it up with:

- Ssh server
- Python3, with pip3

## How Ansible works ?

### Inventory file

- The Inventory is a description of the nodes that can be accessed by Ansible. 
- The Inventory is described by a configuration file, in INI or YAML format, whose default location is in /etc/ansible/hosts. 
- The configuration file lists either the IP address or hostname of each node that is accessible by Ansible. In addition, nodes can be assigned to groups

---
# How Ansible works ?
### ansible modules

- Modules are mostly standalone and can be written in a standard scripting language (such as Python, Perl, Ruby, Bash, etc.). 
- One of the guiding properties of modules is idempotence, which means that even if an operation is repeated multiple times (e.g., upon recovery from an outage), it will always place the system into the same state

---
# How Ansible works ?
### ansible playbooks

- Playbooks are YAML files that express configurations, deployment, and orchestration in Ansible, and allow Ansible to perform operations on managed nodes. 
- Each Playbook maps a group of hosts to a set of roles. Each role is represented by calls to Ansible tasks

---
# How Ansible works ?

### ansible roles

- Each Playbook maps a group of hosts to a set of roles. Each role is represented by calls to Ansible tasks.

