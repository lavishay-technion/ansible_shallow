
---

# Templates with Jinja2


---

# Templates

#### what will we see ?

- Jinja2 template language
- Jinja2 module
- jinja2 filters
    - [RTFM playbook filters](https://docs.ansible.com/ansible/2.7/user_guide/playbooks_filters.html) 

---

# Jinja2 templates language

Ansible uses [Jinja2 template engine](https://jinja.palletsprojects.com/en/3.1.x) to enable dynamic expressions and access to variables and facts. You can use jinja2 with the `template` module.

- Use template engine in playbooks directly, by passing values through template to task names and more.
- Use all the standard filters and tests included in Jinja2. 

---

#  Jinja2 templates language (cont.)

Jinja2 templates combine plain text files and special syntax to define and substitute dynamic content, embed variables, expressions, loops, and even conditional statements to generate complex output. According to the documentation, expressions are enclosed in double curly braces `{{ }}`, statements in curly braces with percent signs `{% %}`, and comments in `{# #}.`

---

# Examples

- [template example](../../example_template.j2)
- [simple use](../../00.yaml)
- [config with variables](../../01.yaml)
- [nginx provision](../../02.yaml)

> `[!]` Note: value swapping in templates happens before the task is executed on the target on the `anisble host`

---

# Practice

- Use sshd configuration file below to create sshd.j2 template
    - Change port to variable {{sshd_port}}
    - Change listen address to {{ sshd_address}}
    - Change usepam to {{ pam_use }}
- Create vars.yaml file that will variables
    - sshd_port = 22
    - sshd_address = 0.0.0.0
    - pam_use = yes
- Create task with template module
    - Setup vars.yaml file for the task
    - Use copy module to backup the remote sshd config on all hosts
    - Use template module to deploy the sshd config to all hosts
    - Test by connecting to one of the host to validate

```ini
Include /etc/ssh/sshd_config.d/*.conf
Port 22
ListenAddress 0.0.0.0
PubkeyAuthentication yes
ChallengeResponseAuthentication no
UsePAM yes
AcceptEnv LANG LC_*
Subsystem       sftp    /usr/lib/openssh/sftp-server
```

```yaml

---

-
  host: all
  become: True
  tasks:
    - name: backup remote sshd config
        copy:
            src: /etc/ssh/sshd_config
            dest: /etc/ssh/sshd_config.bk
            remote_src: True

    - name: Template ssh config
        template:
            src: sshd.j2
            dest: /etc/ssh/sshd_config

```