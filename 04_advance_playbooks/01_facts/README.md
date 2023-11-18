
---

# Ansible Facts

---

- The setup module, and how this relates to fact gathering
- Filtering for specific facts
- The creation of custom facts
- The execution of custom facts
- How custom facts can be used in environments, without super user access
- [RTFM setup module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/setup_module.html)

---

# Examples

- [Setting facts](../../00_our_fact.yaml)
- [Setting multiple facts](../../01_multi_fact.yaml)
- [Set conditional facts](../../02_condition_fact.yaml)

---

# Practice

- Create task for setting modules

---

# Custom Facts

- Can be written in any language
- Return a JSON structure
- (or) Returns an ini structure
- By default, expects to use /etc/ansible/facts.d

---

# Examples
- [Example fact script](../../fact_script.sh)
- [Setting custom facts](../../03_custom_fact.yaml)

---

# Practice

- Create shell script that returns json format of python version installed on your system
- Create playbook with tasks that:
    - Creates /etc/ansible/facts.d/ folder on all nodes
    - Copies the shell script to remote location of /etc/ansible/facts.d/ on all hosts with name of `python_version.fact`
    - Set the script to be custom fact on remote hosts under /etc/ansible/facts.d/
    - Check with debug module the value of ansible_fact called ansible_local

```sh
#!/bin/bash

python_ver=$(python3 --version | cut -d' ' -f2)

cat << EOF
{ "Python_version": "${python_ver}" }
EOF
```

```yaml
---

- 

  hosts: db
  gather_facts: True

  tasks:
    - name: Create /etc/ansible/facts.d/ folder
      file:
        path: /etc/ansible/facts.d/
        state: directory
        mode: 755
    - name: Copy script to fact folder
        copy:
          src: python.sh
          dest: /etc/ansible/facts.d/python_version.fact
    - name:
        setup:
          filter: 
            - 'ansible_local'

```