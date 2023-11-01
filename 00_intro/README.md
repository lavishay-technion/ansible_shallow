# Ansible Shallow Dive



.footnote: Created By Alex M. Schapelle, VAioLabs.io


---

# About The Course Itself ?

We'll learn several topics mainly focused on:

- What is Ansible ?
- Who needs AnsibleS ?
- How Ansible works ?
- How to manage Ansible in various scenarios ?


---

# Who is this course for ?

- The name kind of mentions it:
    - System administrators who wish to learn basic Ansible usage.
    - SysOps who are moving to DevOps jobs.
    - DevOps who wish to implement infrastructure as a code (IaC) with declarative language.
- But it also can be useful for:
    - Junior DevOps who wish to gain minimal knowledge of IaC.
    - Junior software developers who have no knowledge of IaC.

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
    - Bash/PowerShell Script
    - Python3 / Pytest / Pylint / Flask
    - Go / Gin / Echo
    - Ansible / Terraform
- Do you have any hobbies ?
- Do you pledge your alliance to [Emperor of Man kind](https://warhammer40k.fandom.com/wiki/Emperor_of_Mankind) ?

---

# History

Many developers and system administrators manage servers by logging into them via SSH, making changes, and logging off. Some of these changes would be documented, some would not. If an admin needed to make the same change to many servers, the admin would manually log into each server and repeatedly make this change.

Some admins may use shell scripts to try to reach some level of sanity, but I’ve yet to see a complex shell script that handles all edge cases correctly while synchronizing multiple servers’ configuration and deploying new code

But there’s a reason why many developers and sysadmins stick to shell scripting and command-line configuration: it’s simple and easy-to-use, and they’ve had years of experience using bash and command-line tools. Why throw all that out the window and learn a new configuration language and methodology?

---

# History (cont.)

### Enter Ansible

<img src="../99_misc/.img/ansible_logo.png" alt="ansible_logo" style="float:right;width:180px;">

The term "Ansible" was coined by Ursula K. Le Guin in her 1966 novel Rocannon's World, and refers to fictional **instantaneous communication systems**.

The Ansible tool was developed by [Michael DeHaan](), the author of the provisioning server application Cobbler and co-author of the Fedora Unified Network Controller (Func) framework for remote administration.

Ansible, Inc. (originally AnsibleWorks, Inc.) was the company founded in 2013 by Michael DeHaan, Timothy Gerla, and Saïd Ziouani to commercially support and sponsor Ansible. Red Hat acquired Ansible in October 2015.

Ansible is included as part of the Fedora distribution of Linux, owned by Red Hat, and is also available for Red Hat Enterprise Linux, CentOS, openSUSE, SUSE Linux Enterprise, Debian, Ubuntu, Scientific Linux, and Oracle Linux via Extra Packages for Enterprise Linux (EPEL), as well as for other operating systems

As we can see, Ansible was built by developers and sysadmins who know the command line—and want to make a tool that helps them manage their servers exactly the same as they have in the past, but in a repeatable and centrally managed way. Ansible also has other tricks up its sleeve, making it a true Swiss Army knife for people involved in DevOps.


---

# What is Ansible?

As James Spurin explained in one of his videos, Ansible is multitude of tools, modules, and software defined Infrastructre, that are collectively ansible tool set.
For me and majority of other users, Ansible is an open-source software provisioning, configuration management, and application-deployment tool enabling infrastructure as code.
You are welcome to use either of those definitions.

#### Why we need it?

Lets assume that you have a couple of remote instances running some services. Due to some issue or upgrade in those services you might need to alter the configurations in those remote instances. What you would have to do is make those changes in each of those instances manually. The importance of a configuration management system comes in handy in a situation like this. Do the configuration changes in a master instance and it will make sure that all other instances would have the proper changes. Ansible is a such configuration management tool. Ansible connects with its other instances using SSH. Therefore there is no concept such as an agent when using Ansible

---

# Ansible (cont.)

#### Do we still need  Bash/Python/Ruby/Go scripts, then ?

<img src="../99_misc/.img/yesbutno.png" alt="yesbutno" style="float:right;width:400px;">

<img src="../99_misc/.img/logos.png" alt="logos" style="float:right;width:600px;">

Let's discuss:

- Code development process
- Declarative Vs. Scripted
- Code maintainence
- Complexity management

---

# What are Ansible's prerequisites ?

Ansible requires Python to be installed on all `managed` machines, including `pip` package manager along with configuration-management software and its dependent packages. 
Managed network devices require no extra dependencies and are agent less. We can sum it up with:
- Ssh server
- Python3, with pip3

> `[!]` Note: essentially any minimal  UNIX/Linux machine should be managed with Ansible. In cases where python and other required packages are not found, Ansible can adapt,e.g Ansible manages windows machines with `Win-RM` and powershell.

### How Ansible works ?

Ansible uses combination of inventories, executable, modules, yaml playbooks and playbook roles.

#### Inventories and Inventory file

- The inventory is a description of the nodes that can be accessed by Ansible. 
- `INI` or `YAML` are used as a default configuration format, while default configuration file is either located at `/etc/ansible/hosts` or under the users home directory. Depends on type of installation. 
- The configuration file lists either the IP address or hostname of each node that is accessible by Ansible. In addition, nodes can be assigned to groups

---

# How Ansible works ? (cont.)

#### Ansible modules

- Modules are mostly standalone and can be written in a standard scripting language (such as Python, Perl, Ruby, Bash, etc.). 
- One of the guiding properties of modules is idempotence, which means that even if an operation is repeated multiple times (e.g., upon recovery from an outage), it will always place the system into the same state

#### Ansible playbooks

- Playbooks are YAML files that express configurations, deployment, and orchestration in Ansible, and allow Ansible to perform operations on managed nodes. 
- Each Playbook maps a group of hosts to a set of roles. Each role is represented by calls to Ansible tasks

### Ansible roles

- Each Playbook maps a group of hosts to a set of roles. Each role is represented by calls to Ansible tasks.

