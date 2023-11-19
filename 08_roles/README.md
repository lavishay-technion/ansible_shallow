
---

# Ansible Roles
<img src="../../99_misc/.img/galaxy.png" alt="galaxy" style="float:right;width:400px;">

---

Up until now, we shallow dived into ansible and ansible-playbook, while the idea of all we went through was to work on single command or single playbook. Yet as with everything software connected, working on single file may become tiresome and hard to maintain.
Usually in software development, it is standard to separate part of the software into smaller, digestible parts that can be easily maintained in long period of time. 

#### Enter Ansible Roles

Ansible Role is essentially a way to bundle automation tasks, handlers, default variables, and other assets together. It acts like a blueprint, allowing users to reuse, share, and manage automation structures with ease. By using Ansible Roles, tasks become modular and more straightforward, promoting reusability and simplicity in defining complex configurations and automation

---

# Importance and use cases

The concept of the "Ansible Role" becomes highly valuable when you need to manage complex systems or workflows. Roles are indispensable for organizing and modularizing code into reusable units. They help in breaking down complex tasks into simpler, more manageable pieces, thus making the automation workflows less cluttered and more understandable.

Use cases of Ansible Roles are vast, ranging from configuring system prerequisites and managing users to deploying applications and ensuring that specific services are running on servers. Due to the modular nature of roles, they can be easily shared across different projects, promoting code reuse and consistency.

---

# Architecture and components

An "Ansible Role" is containing several components or directories, each holding specific types of content. Key components include:

- `Tasks`: The main list of tasks that the role will execute.
- `Handlers`: Contains handlers, which may be used by this role or even outside this role.
- `Defaults`: Default variables for the role.
- `Vars`: Other variables for the role.
- `Files` and `Templates`: Contains files or templates which can be deployed by this role.

The structure looks as follows:

<img src="../../99_misc/.img/ansible_role.png" alt="roles" style="float:right;width:400px;">

> `[!]` Note: this structure can be created manually, yet it is suggested to use `ansible-galaxy` instead, as shown in next segment

---

# Initialization

To initialize or create a new Ansible Role, you can use the ansible-galaxy init command, followed by the role name. For example:

```sh
ansible-galaxy init my_role
```

This command will create a new directory with the name `my_role`, including it with the necessary directories and files based on the default structure.

lets populate some of these files with task and try to use the role:

```yaml
# role_name/tasks/main.yaml
---
- name: Install nginx
  apt:
    name: nginx
    state: present
```

```yaml
# role_name/handlers/main.yaml
---
- name: Restart nginx
  service:
    name: nginx
    state: restarted
```

```yaml
# role_name/defaults/main.yaml
---
nginx_port: 80
```

---

# Practice

- Create role named web_role
- Copy examples from above and insert them into the relevant folders/files


---

# Using ansible roles

#### Including roles in playbooks

Ansible roles are designed to be reusable components in your automation workflows. To leverage the functionalities defined in roles, you include them in playbooks. Here is how you can incorporate Ansible Roles within a playbook:


```yaml
---
# outside of my_role folder in file name my_playbook.yaml
- hosts: web
  roles:
    - role: nginx_role
```

In this example, the playbook is assigned to run on web_servers, and it includes an Ansible Role named nginx_role

---

# Executing the role playbook

Run the playbook using the ansible-playbook command, and the role will be executed on the targeted hosts

```sh
ansible-playbook my_playbook.yaml
```

---

# Practice

- Create playbook called web_playbook.yaml
- Run web_playbook against web hosts

---

# Role Dependencies

Roles can depend on other roles, meaning one role can invoke another. Defining dependencies is crucial for managing complex workflows where tasks are interrelated. Dependencies are typically listed in the meta/main.yaml file inside the role directory.
yaml

```yaml
# meta/main.yaml
dependencies:
  - role: common
```

In this snippet, the Ansible Role has a dependency on another role named common, which would be executed first.

---

# Passing variables to roles

Variables make Ansible Roles highly customizable. When using a role in a playbook, you can pass variables to it to modify its behavior.

```yaml
---
- hosts: web_servers
  roles:
    - role: nginx_role
      vars:
        nginx_port: 8080
```
This playbook executes the nginx_role, passing a variable that sets the Nginx port to 8080

