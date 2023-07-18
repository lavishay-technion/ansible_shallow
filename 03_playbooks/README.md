
---

# Ansible Playbooks

.footer: Created By Alex M. Schapelle, VAioLabs.io

---

# Ansible Playbook/YAML Structure

- By default ansible runs playbooks (YAML files) with `ansible-playbook` executable.
  - For the executable to run correctly it must get certain terms:
    - The file should start with triple dashes ( - - - ).
        - Not Mandatory, yet proved to be useful, in case you are storing multiple playbooks under one file.
    - Initial data must be provided as `Mappings`
    - Inventory file must be setup in correct manner:
        - Groups.
        - Hosts.
        - Access keys.
        - So on ...
    - List of tasks must be defined in logical order of behavior.
        - Each task must use required module with defined values.
    - Most YAML rules must be abided.

---

# Ansible Playbook/YAML Structure (cont.)

As an example:

- Using simple yaml playbook to ping list of nodes
  - `nodes` is a predefined group of server/vms/desktops...
   
```yaml
---
- hosts: nodes
  tasks:
    - name: ping all nodes
      ping:
```
---

# Practice
- Create folder Playbook:
  - Create initial playbook called **playbook-ping.yaml**
    - In playbooks create a task that pings all possible hosts
    - Add another task the pings web servers
    - Add other task pings db servers

---

# Ansible Mappings: What to define ?

-  List of nodes
  - Groups of server defines in `hosts.ini` or inventory file
- Permission escalation
  - When we run some tasks, we will need to use escalated permissions of admin user, so `sudo` or `su -c` may be invoked
  - It can be specified which way of permission escalation is preferred
- Remote system data gathering
  - With `setup` module we can gather information in regards to remote clients from inventory
- Whether to stop or not when errors occur
- Variable files
  - Instead of keeping all the info in one file, we can save pre-defined variables in external file and use for our use cases

---
# Ansible Mappings: What to define ?(cont.)

- Lets see an example:

```yaml
---
- hosts: nodes
  ignore_errors: true
  gather_facts: true
  become: true
  become_method: sudo
  tasks:
    - name : ping IP address from remote hosts
      ping :

```
---
# Practice
- In the playbooks folders
  - Create playbook named **playbook-setup.yaml**
    - Use module setup get all the information in regards to all nodes

---

# Ansible modules in playbooks

- Modules are heart of Ansible
  - They are python written code.
    - Modules can be developed based on Ansible community development guidelines.
  - They provide basic and built-in functionality with which ansible automates things.
  - Combination of Modules with YAML provides us with automation with ansible.
- All the modules described at ansible command module work in similar manner.

---

# Builtin Modules

- file
- lineinfile/replace
- find
- apt/yum/dnf/pip
- archive
- command/shell/cmd
- stat
- get-url
- user/group
- systemd/service

---
# Special Builtin Modules

- debug
- setup
- register

---

# Lookup Modules

- dict – returns key/value pair items from dictionaries
- env – Read the value of environment variables
- fileglob – list files matching a patterns
- first_found – return first file found from list
- indexed_items – rewrites lists to return ‘indexed items’
- ini – read data from a ini file
- inventory_hostnames – list of inventory hosts matching a host pattern
- items – list of items
- lines – read lines from command
- list – simply returns what it is given.
- pipe – read output from a command
- template – retrieve contents of file after templating with Jinja2
- varnames – Lookup matching variable names
- vars – Lookup templated value of variables

---
<!-- # Ansible Mappings: what to define ?(cont.)

- Another example

```yaml
---
- hosts: web
  ignore_errors: true
  gather_facts: false
  become: true
  become_method: sudo
  tasks:

    - name: copy systemd conf file for flask application
      copy:
        src: ../files/flask.service
        dest: /etc/systemd/system

    - name: enabling and starting flask application
      systemd:
        name: flask
        state: started
        daemon_reload: yes
        enabled: yes

```

--- -->
---

# What now ? Practice !

Here is a [link](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html) to basic modules of ansible modules

Please refer to link and practice them as follows.

---

# Practice

- Create Ansible project that sets up 5 vm's (or containers):
  - All containers must be mix of linux distributions.
    - 2 of containers must be web servers.
    - 2 servers must be mysql server and worker.
  - Create or use existing flask project that will be copied to `web server1`.
  - Use `web server2` to connect to flask app on `web server1`.
  - Flask project should connect to `db1` container on different network.

---

# Storing And Passing Information 

## Fact gathering

- Ansible **facts** are simply various properties regarding a given remote system.
- The `setup` module can retrieve facts.
- The filter parameter takes regex to allow you to prune fact output.
- Facts are gathered by default in Ansible playbook execution.
- The keyword `gather_facts` may be set in playbook to change fact gathering behavior.
- It is possible to print Ansible facts in files using variables.
- Facts may be filtered using the setup module ad-hoc by passing a value for the filter parameter.
- It is possible to use `"{{ ansible_facts }}"` for conditional plays based on facts.

---
# Variables

Typical uses of variables:

- Customize configuration values.
- Hold return values of commands.
- Ansible has many default variables for controlling Ansible’s behavior.
- Variable names should be letters, numbers, and underscores.
- Variables should always start with a letter.
- Examples of **valid** variable names:
    - foobar
    - foo_bar
    - foo5

---

# Variables (cont.)

Examples of *invalid* variable names:
    - foo-bar
    - 1foobar
    - foo.bar

- Variables can be scoped by group, host, or within a playbook.
- Variables may be used to store a **simple text or numeric value**.

- Example: 

```yaml 
month: January
```
---

# Variables (cont.)

- Variables may also be used to store simple **lists**.
- Example:
```yaml
colors:
  - red
  - blue
  - yellow
```
- Additionally, variables may be used to store python style dictionaries.
- A **dictionary** is a list of key value pairs.
- Example:
```yaml
person:
  name: sam
  age: 4
  favorite_color: green
```
---
# Variables (cont.)

Variables may be defined in a number of ways:

Via command line argument: 

  - Within a variables ﬁle.
  - Within a playbook.
  - Within an inventory ﬁle.

How to defined variables via the command line:

  - Use the --extra-vars or -e ﬂag defined within a playbook.
  - CLI Example: `ansible-playbook service.yml -e "target_hosts=localhost target_service=httpd"`

---

# Variables (cont.)

Defining variables within a playbook. 

Playbook Example:

```yaml
---
- hosts: webs
  become: yes
  vars:
    target_service: nginx
    target_state: started
  tasks:
    - name: Ensure target service is at target state
      service:
      name: "{{ target_service }}"
      state: "{{ target_state }}"
```

---

# Variables (cont.)

>Note: Variables are referenced using double curly braces.
>We **ALSO NEED** to wrap variable names or statements containing variable names in double quotes.
- Example: 

```yaml
hosts: "{{ my_host_var }}"
```

- Variables may also be stored in files and included using the vars_file directive.

---
# Variables (cont.)

## Example
Variable ﬁle:

```ini

# file: /home/ansible/web_vars.ini
target_service: nginx
target_state: started

```

```yaml
---
- hosts: webs
  become: yes
  vars_files:
    - /home/ansible/web_vars.ini
  tasks:
    - name: Ensure target service is at target state
      systemd:
      name: "{{ target_service }}"
      state: "{{ target_state }}"

```

---

# Variables (cont.)

- The **register** module is used to store task output in a dictionary variable.
- It essentially can save the results of a command.
- Several attributes are available: return code, stderr, and stdout.
- Example:

```yaml
- hosts: all
  tasks:
   - shell: cat /etc/motd
     register: motd_contents

   - shell: echo "motd contains the word hi"
     when: motd_contents.stdout.find('hi') != -1
```
---

# Practice

Create playbook with pre-defined variables:

- var.yml, with key `hello` and value `hello world !!!`
- main.yml, that uses variables file and prints it using command module.

---
# Privilege escalation: become

Ansible uses existing privilege escalation systems to execute tasks with root privileges or with another user’s permissions. Because this feature allows you to `become` another user, different from the user that logged into the machine (remote user), we call it `become`. The `become` keyword uses existing privilege escalation tools like sudo, su, pfexec, doas, pbrun, dzdo, ksu, runas, machinectl and others.

---

# Privilege escalation(cont.)
## Using become

You can control the use of become with play or task directives, connection variables, or at the command line. If you set privilege escalation properties in multiple ways, review the general precedence rules to understand which settings will be used.

A full list of all become plugins that are included in Ansible can be found in the Plugin List.

---

# Privilege escalation(cont.)
## Become directives

You can set the directives that control become at the play or task level. You can override these by setting connection variables, which often differ from one host to another. These variables and directives are independent. For example, setting become_user does not set become.

- `become`: set to yes to activate privilege escalation.
- `become_user`: set to user with desired privileges — the user you become, NOT the user you login as. Does NOT imply become: yes, to allow it to be set at host level. Default value is root.
- `become_method`: (at play or task level) overrides the default method set in ansible.cfg, set to use any of the Become plugins.
- `become_flags`: (at play or task level) permit the use of specific flags for the tasks or role. One common use is to change the user to nobody when the shell is set to *nologin*. Added in Ansible 2.2.

---

# Privilege escalation(cont.)
## Become directives

For example, to manage a system service (which requires root privileges) when connected as a non-root user, you can use the default value of become_user (root):

```yaml
- name: Ensure the httpd service is running
  service:
    name: httpd
    state: started
  become: yes
```
To run a command as the apache user:
```yaml
- name: Run a command as the apache user
  command: some-command
  become: yes
  become_user: apache
```

To specify a password for sudo, run ansible-playbook with `--ask-become-pass` or -K for short. If you run a playbook utilizing become and the playbook seems to hang, most likely it is stuck at the privilege escalation prompt. Stop it with CTRL-c, then execute the playbook with -K and the appropriate password.

---

# Privilege escalation(cont.)

## Risks and limitations of `become`

Ansible modules are executed on the remote machine by first substituting the parameters into the module file, then copying the file to the remote machine, and finally executing it there.

Everything is fine if the module file is executed without using `become`, when the `become_user` is root, or when the connection to the remote machine is made as root. In these cases Ansible creates the module file with permissions that only allow reading by the user and root, or only allow reading by the unprivileged user being switched to.

---
# Privilege escalation(cont.)

## Risks and limitations of `become`

However, when both the connection user and the become_user are unprivileged, the module file is written as the user that Ansible connects as (the remote_user), but the file needs to be readable by the user Ansible is set to become. The details of how Ansible solves this can vary based on platform. However, on `POSIX` systems, Ansible solves this problem in the following way:

First, if `setfacl` is installed and available in the remote PATH, and the temporary directory on the remote host is mounted with `POSIX` filesystem ACL support, Ansible will use `POSIX` ACLs to share the module file with the second unprivileged user.

Next, if `POSIX` ACLs are not available or `setfacl` could not be run, Ansible will attempt to change ownership of the module file using chown for systems which support doing so as an unprivileged user.

In Ansible 2.11, it will try `chmod +a` which is a macOS-specific way of setting ACLs on files.

In Ansible 2.10, if all of the above fails, Ansible will then check the value of the configuration setting ansible_common_remote_group. Many systems will allow a given user to change the group ownership of a file to a group the user is in. As a result, if the second unprivileged user (the become_user) has a UNIX group in common with the user Ansible is connected as (the remote_user), and if `ansible_common_remote_group` is defined to be that group, Ansible can try to change the group ownership of the module file to that group by using `chgrp`, thereby likely making it readable to the become_user.

---

# Using Loops in Ansible
Ansible offers the loop, with_<lookup>, and until keywords to execute a task multiple times

## Comparing loop and with_*

- The with_<lookup> keywords rely on Lookup plugins - even items is a lookup.
- The loop keyword is equivalent to with_list, and is the best choice for simple loops.
- The loop keyword will not accept a string as input, see Ensuring list input for loop: using query rather than lookup.

Generally speaking, any use of with_* covered in Migrating from with_X to loop can be updated to use loop.
Be careful when changing with_items to loop, as with_items performed implicit single-level flattening. You may need to use flatten(1) with loop to match the exact outcome. For example, to get the same output as:
```yaml
with_items:
  - 1
  - [2,3]
  - 4
```
you would need rewrite it as:

```yaml
loop: "{{ [1, [2, 3], 4] | flatten(1) }}"
```
Any with_* statement that requires using lookup within a loop should not be converted to use the loop keyword. For example, instead of doing:
```yaml
loop: "{{ lookup('fileglob', '*.txt', wantlist=True) }}"
```
it’s cleaner to keep
```yaml
with_fileglob: '*.txt'
```

---

# Standard loops

## Iterating over a simple list

Repeated tasks can be written as standard loops over a simple list of strings. You can define the list directly in the task.
```yaml
- name: Add several users
  ansible.builtin.user:
    name: "{{ item }}"
    state: present
    groups: "wheel"
  loop:
     - test-user1
     - test-user2
```

You can define the list in a variables file, or in the ‘vars’ section of your play, then refer to the name of the list in the task.
```yaml
loop: "{{ some-list }}"
```
---
# Standard loops

## Iterating over a simple list

Either of these examples would be the equivalent of
```yaml
- name: Add user test-user1
  ansible.builtin.user:
    name: "test-user1"
    state: present
    groups: "wheel"

- name: Add user test-user2
  ansible.builtin.user:
    name: "test-user2"
    state: present
    groups: "wheel"
```
---

# Standard loops

## Iterating over a simple list

You can pass a list directly to a parameter for some plugins. Most of the packaging modules, like yum and apt, have this capability. When available, passing the list to a parameter is better than looping over the task. For example
```yaml
- name: Optimal yum
  ansible.builtin.yum:
    name: "{{ list_of_packages }}"
    state: present

- name: Non-optimal yum, slower and may cause issues with interdependencies
  ansible.builtin.yum:
    name: "{{ item }}"
    state: present
  loop: "{{ list_of_packages }}"
```
Check the module documentation to see if you can pass a list to any particular module’s parameter(s).

---
# Standard loops

## Iterating over a list of hashes

If you have a list of hashes, you can reference sub-keys in a loop. For example:
```yaml
- name: Add several users
  ansible.builtin.user:
    name: "{{ item.name }}"
    state: present
    groups: "{{ item.groups }}"
  loop:
    - { name: 'test-user1', groups: 'wheel' }
    - { name: 'test-user2', groups: 'root' }
```
When combining conditionals with a loop, the when: statement is processed separately for each item.

---

# Standard loops

## Iterating over a dictionary

To loop over a dict, use the dict2items:
```yaml
- name: Using dict2items
  ansible.builtin.debug:
    msg: "{{ item.key }} - {{ item.value }}"
  loop: "{{ tag_data | dict2items }}"
  vars:
    tag_data:
      Environment: dev
      Application: payment
```
Here, we are iterating over tag_data and printing the key and the value from it.

---
# Standard loops

## Registering variables with a loop

You can register the output of a loop as a variable. For example
```yaml
- name: Register loop output as a variable
  ansible.builtin.shell: "echo {{ item }}"
  loop:
    - "one"
    - "two"
  register: echo
```
---

# Standard loops

## Registering variables with a loop

When you use register with a loop, the data structure placed in the variable will contain a results attribute that is a list of all responses from the module. This differs from the data structure returned when using register without a loop.
```json
{
    "changed": true,
    "msg": "All items completed",
    "results": [
        {
            "changed": true,
            "cmd": "echo \"one\" ",
            "delta": "0:00:00.003110",
            "end": "2013-12-19 12:00:05.187153",
            "invocation": {
                "module_args": "echo \"one\"",
                "module_name": "shell"
            },
            "item": "one",
            "rc": 0,
            "start": "2013-12-19 12:00:05.184043",
            "stderr": "",
            "stdout": "one"
        },
        {
            "changed": true,
            "cmd": "echo \"two\" ",
            "delta": "0:00:00.002920",
            "end": "2013-12-19 12:00:05.245502",
            "invocation": {
                "module_args": "echo \"two\"",
                "module_name": "shell"
            },
            "item": "two",
            "rc": 0,
            "start": "2013-12-19 12:00:05.242582",
            "stderr": "",
            "stdout": "two"
        }
    ]
}
```

---

# Standard loops

## Registering variables with a loop

Subsequent loops over the registered variable to inspect the results may look like this 
```yaml
- name: Fail if return code is not 0
  ansible.builtin.fail:
    msg: "The command ({{ item.cmd }}) did not have a 0 return code"
  when: item.rc != 0
  loop: "{{ echo.results }}"
```
During iteration, the result of the current item will be placed in the variable.
```yaml
- name: Place the result of the current item in the variable
  ansible.builtin.shell: echo "{{ item }}"
  loop:
    - one
    - two
  register: echo
  changed_when: echo.stdout != "one"
```

---
# Conditionals 
In a playbook, you may want to execute different tasks, or have different goals, depending on the value of a fact (data about the remote system), a variable, or the result of a previous task. You may want the value of some variables to depend on the value of other variables. Or you may want to create additional groups of hosts based on whether the hosts match other criteria. You can do all of these things with conditionals.

Ansible uses Jinja2 tests and filters in conditionals. Ansible supports all the standard `tests` and `filters`, and adds some unique ones as well.

---
# Basic conditionals with `when`

The simplest conditional statement applies to a single task. Create the task, then add a when statement that applies a test. The when clause is a raw Jinja2 expression without double curly braces (see group_by_module). When you run the task or playbook, Ansible evaluates the test for all hosts. On any host where the test passes (returns a value of True), Ansible runs that task. For example, if you are installing mysql on multiple machines, some of which have SELinux enabled, you might have a task to configure SELinux to allow mysql to run. You would only want that task to run on machines that have SELinux enabled:
```yaml
tasks:
  - name: Configure SELinux to start mysql on any port
    ansible.posix.seboolean:
      name: mysql_connect_any
      state: true
      persistent: yes
    when: ansible_selinux.status == "enabled"
    # all variables can be used directly in conditionals without double curly braces
```
---

# Conditionals based on `ansible_facts`

Often you want to execute or skip a task based on facts. Facts are attributes of individual hosts, including IP address, operating system, the status of a filesystem, and many more. With conditionals based on facts, You can:

- install a certain package only when the operating system is a particular version.
- skip configuring a firewall on hosts with internal IP addresses.
- perform cleanup tasks only when a filesystem is getting full.

See Commonly-used facts for a list of facts that frequently appear in conditional statements. Not all facts exist for all hosts. For example, the `lsb_major_release` fact used in an example below only exists when the lsb_release package is installed on the target host. To see what facts are available on your systems, add a debug task to your playbook:
```yaml
- name: Show facts available on the system
  ansible.builtin.debug:
    var: ansible_facts
```
---

# Conditionals based on `ansible_facts` (cont.)

Here is a sample conditional based on a fact:
```yaml
tasks:
  - name: Shut down Debian flavored systems
    ansible.builtin.command: /sbin/shutdown -t now
    when: ansible_facts['os_family'] == "Debian"
```

---

# Conditionals based on `ansible_facts` (cont.)

If you have multiple conditions, you can group them with parentheses:
```yaml
tasks:
  - name: Shut down CentOS 6 and Debian 7 systems
    ansible.builtin.command: /sbin/shutdown -t now
    when: (ansible_facts['distribution'] == "CentOS" and ansible_facts['distribution_major_version'] == "6") or
          (ansible_facts['distribution'] == "Debian" and ansible_facts['distribution_major_version'] == "7")
```
---

# Conditionals based on `ansible_facts` (cont.)

You can use logical operators to combine conditions. When you have multiple conditions that all need to be true (that is, a logical and), you can specify them as a list:

```yaml
tasks:
  - name: Shut down CentOS 6 systems
    ansible.builtin.command: /sbin/shutdown -t now
    when:
      - ansible_facts['distribution'] == "CentOS"
      - ansible_facts['distribution_major_version'] == "6"
```
If a fact or variable is a string, and you need to run a mathematical comparison on it, use a filter to ensure that Ansible reads the value as an integer:
```yaml
tasks:
  - ansible.builtin.shell: echo "only on Red Hat 6, derivatives, and later"
    when: ansible_facts['os_family'] == "RedHat" and ansible_facts['lsb']['major_release'] | int >= 6
```

--- 
# Conditions based on `registered variables`

Often in a playbook you want to execute or skip a task based on the outcome of an earlier task. For example, you might want to configure a service after it is upgraded by an earlier task. To create a conditional based on a registered variable:
- Register the outcome of the earlier task as a variable.
- Create a conditional test based on the registered variable.

---

# Conditions based on `registered variables`

You create the name of the registered variable using the register keyword. A registered variable always contains the status of the task that created it as well as any output that task generated. You can use registered variables in templates and action lines as well as in conditional when statements. You can access the string contents of the registered variable using variable.stdout. For example:

```yaml
- name: Test play
  hosts: all

  tasks:

      - name: Register a variable
        ansible.builtin.shell: cat /etc/motd
        register: motd_contents

      - name: Use the variable in conditional statement
        ansible.builtin.shell: echo "motd contains the word hi"
        when: motd_contents.stdout.find('hi') != -1
```
---

# Conditions based on `registered variables`

You can use registered results in the loop of a task if the variable is a list. If the variable is not a list, you can convert it into a list, with either stdout_lines or with variable.stdout.split(). You can also split the lines by other fields:
```yaml
- name: Registered variable usage as a loop list
  hosts: all
  tasks:

    - name: Retrieve the list of home directories
      ansible.builtin.command: ls /home
      register: home_dirs

    - name: Add home dirs to the backup spooler
      ansible.builtin.file:
        path: /mnt/bkspool/{{ item }}
        src: /home/{{ item }}
        state: link
      loop: "{{ home_dirs.stdout_lines }}"
      # same as loop: "{{ home_dirs.stdout.split() }}"
```
---

# Conditions based on `registered variables`
The string content of a registered variable can be empty. If you want to run another task only on hosts where the stdout of your registered variable is empty, check the registered variable’s string contents for emptiness:
```yaml
- name: check registered variable for emptiness
  hosts: all

  tasks:

      - name: List contents of directory
        ansible.builtin.command: ls my-dir
        register: contents

      - name: Check contents for emptiness
        ansible.builtin.debug:
          msg: "Directory is empty"
        when: contents.stdout == ""
```
---

# Conditions based on `registered variables`

Ansible always registers something in a registered variable for every host, even on hosts where a task fails or Ansible skips a task because a condition is not met. To run a follow-up task on these hosts, query the registered variable for is skipped (not for “undefined” or “default”). See Registering variables for more information. Here are sample conditionals based on the success or failure of a task. Remember to ignore errors if you want Ansible to continue executing on a host when a failure occurs:

```yaml
tasks:
  - name: Register a variable, ignore errors and continue
    ansible.builtin.command: /bin/false
    register: result
    ignore_errors: true

  - name: Run only if the task that registered the "result" variable fails
    ansible.builtin.command: /bin/something
    when: result is failed

  - name: Run only if the task that registered the "result" variable succeeds
    ansible.builtin.command: /bin/something_else
    when: result is succeeded

  - name: Run only if the task that registered the "result" variable is skipped
    ansible.builtin.command: /bin/still/something_else
    when: result is skipped
```

---

# Conditions based on `registered variables`
> Note

> Older versions of Ansible used success and fail, but succeeded and failed use the correct tense. All of these options are now valid.
Conditionals based on variables

You can also create conditionals based on variables defined in the playbooks or inventory. Because conditionals require boolean input (a test must evaluate as True to trigger the condition), you must apply the | bool filter to non boolean variables, such as string variables with content like `yes`, `on`, `1`, or `true`. You can define variables like this:

```yaml
vars:
  epic: true
  monumental: "yes"
```
With the variables above, Ansible would run one of these tasks and skip the other:
---

# Conditions based on `registered variables`
```yaml
tasks:
    - name: Run the command if "epic" or "monumental" is true
      ansible.builtin.shell: echo "This certainly is epic!"
      when: epic or monumental | bool

    - name: Run the command if "epic" is false
      ansible.builtin.shell: echo "This certainly isn't epic!"
      when: not epic
```
If a required variable has not been set, you can skip or fail using Jinja2’s defined test. For example:
```yaml

tasks:
    - name: Run the command if "foo" is defined
      ansible.builtin.shell: echo "I've got '{{ foo }}' and am not afraid to use it!"
      when: foo is defined

    - name: Fail if "bar" is undefined
      ansible.builtin.fail: msg="Bailing out. This play requires 'bar'"
      when: bar is undefined
```
---

# Conditions based on `registered variables`

This is especially useful in combination with the conditional import of vars files (see below). As the examples show, you do not need to use {{ }} to use variables inside conditionals, as these are already implied.
Using conditionals in loops

If you combine a when statement with a loop, Ansible processes the condition separately for each item. This is by design, so you can execute the task on some items in the loop and skip it on other items. For example:
```yaml
tasks:
    - name: Run with items greater than 5
      ansible.builtin.command: echo {{ item }}
      loop: [ 0, 2, 4, 6, 8, 10 ]
      when: item > 5
```
---

# Conditions based on `registered variables`

If you need to skip the whole task when the loop variable is undefined, use the |default filter to provide an empty iterator. For example, when looping over a list:
```yaml
- name: Skip the whole task when a loop variable is undefined
  ansible.builtin.command: echo {{ item }}
  loop: "{{ my-list|default([]) }}"
  when: item > 5
```
---

# Conditions based on `registered variables`

You can do the same thing when looping over a dict:

```yaml
- name: The same as above using a dict
  ansible.builtin.command: echo {{ item.key }}
  loop: "{{ query('dict', my-dict|default({})) }}"
  when: item.value > 5
```
---
# Loading custom facts

You can provide your own facts, as described in Should you develop a module?. To run them, just make a call to your own custom fact gathering module at the top of your list of tasks, and variables returned there will be accessible to future tasks:
```yaml
tasks:
    - name: Gather site specific fact data
      action: site_facts

    - name: Use a custom fact
      ansible.builtin.command: /usr/bin/thingy
      when: my_custom_fact_just_retrieved_from_the_remote_system == '1234'
```
---

# Conditionals with re-use

You can use conditionals with re-usable tasks files, playbooks, or roles. Ansible executes these conditional statements differently for dynamic re-use (includes) and for static re-use (imports). See Re-using Ansible artifacts for more information on re-use in Ansible.
Conditionals with imports

When you add a conditional to an import statement, Ansible applies the condition to all tasks within the imported file. This behavior is the equivalent of Tag inheritance: adding tags to multiple tasks. Ansible applies the condition to every task, and evaluates each task separately. For example, you might have a playbook called main.yml and a tasks file called other_tasks.yml:
```yaml
# all tasks within an imported file inherit the condition from the import statement
# main.yml
- import_tasks: other_tasks.yml # note "import"
  when: x is not defined

# other_tasks.yml
- name: Set a variable
  ansible.builtin.set_fact:
    x: foo

- name: Print a variable
  ansible.builtin.debug:
    var: x
```
---

# Conditionals with re-use

Ansible expands this at execution time to the equivalent of:

```yaml
- name: Set a variable if not defined
  ansible.builtin.set_fact:
    x: foo
  when: x is not defined
  # this task sets a value for x

- name: Do the task if "x" is not defined
  ansible.builtin.debug:
    var: x
  when: x is not defined
  # Ansible skips this task, because x is now defined
```
Thus if x is initially undefined, the debug task will be skipped. If this is not the behavior you want, use an include_* statement to apply a condition only to that statement itself.

---

# Conditionals with re-use

You can apply conditions to import_playbook as well as to the other import_* statements. When you use this approach, Ansible returns a ‘skipped’ message for every task on every host that does not match the criteria, creating repetitive output. In many cases the group_by module can be a more streamlined way to accomplish the same objective; see Handling OS and distro differences.
Conditionals with includes

---

# Conditionals with re-use

When you use a conditional on an include_* statement, the condition is applied only to the include task itself and not to any other tasks within the included file(s). To contrast with the example used for conditionals on imports above, look at the same playbook and tasks file, but using an include instead of an import:

# Includes let you re-use a file to define a variable when it is not already defined
```yaml
# main.yml
- include_tasks: other_tasks.yml
  when: x is not defined

# other_tasks.yml
- name: Set a variable
  ansible.builtin.set_fact:
    x: foo

- name: Print a variable
  ansible.builtin.debug:
    var: x
```
---

# Conditionals with re-use

Ansible expands this at execution time to the equivalent of:
```yaml
# main.yml
- include_tasks: other_tasks.yml
  when: x is not defined
  # if condition is met, Ansible includes other_tasks.yml

# other_tasks.yml
- name: Set a variable
  ansible.builtin.set_fact:
    x: foo
  # no condition applied to this task, Ansible sets the value of x to foo

- name: Print a variable
  ansible.builtin.debug:
    var: x
  # no condition applied to this task, Ansible prints the debug statement
```

By using include_tasks instead of import_tasks, both tasks from other_tasks.yml will be executed as expected. For more information on the differences between include v import see Re-using Ansible artifacts.
