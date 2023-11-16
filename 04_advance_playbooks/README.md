
---

# Ansible Advance Execution

.footer: Created By Alex M. Schapelle, VAioLabs.io

---

# Ansible Variables

#### Extending on variables

We'll go over examples of variables use

---

# Ansible Facts

#### Extending on setup module

- The setup module and how this relates to fact gathering
- Filtering for specific facts
- the creation of custom facts
- the executino of custom facts
- how to use facts without super user

---

- all
- min
- network
- filter

---

# Templating and jinja2

---

# Ansible Modules

---

# Dynamic Inventory

---

# Register and `when`

---

# Loops

---

# Blocks

Blocks create logical groups of tasks. Blocks also offer ways to handle task errors, similar to exception handling in many programming languages.

- Grouping tasks with blocks
- Handling errors with blocks

---

# Grouping tasks with blocks

All tasks in a block inherit directives applied at the block level. Most of what you can apply to a single task (with the exception of loops) can be applied at the block level, so blocks make it much easier to set data or directives common to the tasks. The directive does not affect the block itself, it is only inherited by the tasks enclosed by a block. For example, a when statement is applied to the tasks within a block, not to the block itself.

---

# Block example with named tasks inside the block
```yaml
 tasks:
   - name: Install, configure, and start Apache
     block:
       - name: Install httpd and memcached
         ansible.builtin.yum:
           name:
           - httpd
           - memcached
           state: present

       - name: Apply the foo config template
         ansible.builtin.template:
           src: templates/src.j2
           dest: /etc/foo.conf

       - name: Start service bar and enable it
         ansible.builtin.service:
           name: bar
           state: started
           enabled: True
     when: ansible_facts['distribution'] == 'CentOS'
     become: true
     become_user: root
     ignore_errors: yes
```
---

# Block example with named tasks inside the block (cont.)

In the example above, the ‘when’ condition will be evaluated before Ansible runs each of the three tasks in the block. All three tasks also inherit the privilege escalation directives, running as the root user. Finally, ignore_errors: yes ensures that Ansible continues to execute the playbook even if some of the tasks fail

Names for blocks have been available since Ansible 2.3. We recommend using names in all tasks, within blocks or elsewhere, for better visibility into the tasks being executed when you run the playbook.

---

# Handling errors with blocks

You can control how Ansible responds to task errors using blocks with rescue and always sections.

Rescue blocks specify tasks to run when an earlier task in a block fails. This approach is similar to exception handling in many programming languages. Ansible only runs rescue blocks after a task returns a ‘failed’ state. Bad task definitions and unreachable hosts will not trigger the rescue block.

```yaml
# Block error handling example

 tasks:
 - name: Handle the error
   block:
     - name: Print a message
       ansible.builtin.debug:
         msg: 'I execute normally'

     - name: Force a failure
       ansible.builtin.command: /bin/false

     - name: Never print this
       ansible.builtin.debug:
         msg: 'I never execute, due to the above task failing, :-('
   rescue:
     - name: Print when errors
       ansible.builtin.debug:
         msg: 'I caught an error, can do stuff here to fix it, :-)'
```
You can also add an always section to a block. Tasks in the always section run no matter what the task status of the previous block is.

---

# Block with always section
```yaml
 - name: Always do X
   block:
     - name: Print a message
       ansible.builtin.debug:
         msg: 'I execute normally'

     - name: Force a failure
       ansible.builtin.command: /bin/false

     - name: Never print this
       ansible.builtin.debug:
         msg: 'I never execute :-('
   always:
     - name: Always do this
       ansible.builtin.debug:
         msg: "This always executes, :-)"
```
Together, these elements offer complex error handling.

---

# Block with all sections

```yaml
- name: Attempt and graceful roll back demo
  block:
    - name: Print a message
      ansible.builtin.debug:
        msg: 'I execute normally'

    - name: Force a failure
      ansible.builtin.command: /bin/false

    - name: Never print this
      ansible.builtin.debug:
        msg: 'I never execute, due to the above task failing, :-('
  rescue:
    - name: Print when errors
      ansible.builtin.debug:
        msg: 'I caught an error'

    - name: Force a failure in middle of recovery! >:-)
      ansible.builtin.command: /bin/false

    - name: Never print this
      ansible.builtin.debug:
        msg: 'I also never execute :-('
  always:
    - name: Always do this
      ansible.builtin.debug:
        msg: "This always executes"
```

The tasks in the block execute normally. If any tasks in the block return failed, the rescue section executes tasks to recover from the error. The always section runs regardless of the results of the block and rescue sections.
