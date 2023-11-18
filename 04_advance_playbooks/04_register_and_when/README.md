
---

# Register and when

---

Ansible `register` is a way to capture the output from task execution and store it in a variable. This is an important feature, as this output is different for each remote host, and the basis on that, we can use conditions loops to do some other tasks

---

# Register

We usually run `ansible` command to test out infrastructure, for example:
```sh
ansible all -a 'hostname -s' -o
```
Yet, there are instances when we need to use the output to determine conclusion that `setup` module may not include
- [Saving hostname](../../00_register.yaml)

But saving output without checking it has not much value, thus combination of `register` keyword with `debug` module and `var` keyword. We can get the raw data or just accept the  `stdout` of the returned output
- [User registered data](../../01_reg_output.yaml)
- [User registered data with stdout](../../02_reg_stdout.yaml)


---

# Register (cont.)

You will store the output of your task in these variables on the Ansible Control Server. In simple words, when you want to run a command on a remote computer, store the output in a variable, and use a piece of information from the output later in your plays.

when we run any module and store its output in a variable, we can access similarly detailed information. We will notice all details about the task execution, and related information will be seen in JSON fields.

You will see most of the fields in the output; we will try to explore some of those.

- `changed` – this will be true or false based on the state of remote hosts. If the state changes, then it will contain true, else it will contain
- `cmd` – This is a command which ran on the remote host
- `failed` – if a task failed or not, it has true or false values
- `RC` – return code
- `stderr` – the standard error message in a single line
- `stdout` – the output in a single line

---

# Practice

- Create task that will issue `uptime` command on debian hosts
- Register all output under variable `uptime_register`
- Add task with `debug` module to show the changes of the variable
- Run the playbook to validates that it is working

```yaml
    - name: Exploring Registers
      command: uptime
      register: uptime_register

    - name: show hostname_output
      debug:
        var: uptime_register

```
---

# When 

In many cases, where we wish to use specific module, plugin or command on specific host and wish to check if host answer the criteria, we use `when` keyword
Many conditions can be evaluated with `and` and `or` boolean operators.
- [Setup Modules with when](../../03_setup_when.yaml)
- [Setup Module with when and `and`](../../04_setup_when_and.yaml)
- [Setup Module with when and `or` and `and`](../../05_setup_when_and_or.yaml)
- [Setup Module with when and `or` and `and`](../../06_setup_when_and_list.yaml)


---

# Practice

- Create the task to run `uptime` command that will run only on debian os family distribution
- Run the playbook to validates that it is working

```yaml
    - name: Exploring Registers
      command: uptime
      when: ansible_os_family == "Debian"
```

[RTFM conditions](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html)

---

# When `register` and `when` meet

It's very useful to combine `register` with `when` keyword, due to their beneficial nature. When working on systems, some of them dynamically can be updated, and those parameters may differ from env to env. In those scenarios ansible comes in handy

- [Registering when condition is triggered](../../07_register_when.yaml)
- [Registering only changed](../../08_register_changed.yaml)
- [Registering only when there `is` change](../../09_register_when_is_change.yaml)
- [Registering when there `is` skip](../../10_register_when_is_skip.yaml)


---

# Practice


- Create task that run `uptime` command, that will execute only on debian os family and on version 11 and above
- Run the playbook to validates that it is working

```yaml
    - name: Exploring Registers
      command: uptime
      when: 
        - ansible_os_family == "Debian"
        - ansible_distribution_major_version | int >= 11 
```

