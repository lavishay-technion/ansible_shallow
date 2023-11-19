
---

# Loops

---

# Loops

Ansible offers the `loop`, `with_<lookup>`, and `until` keywords to execute a task multiple times. Examples of commonly-used loops include changing ownership on several files and/or directories with the file module, creating multiple users with the user module, and repeating a polling step until a certain result is reached

> `[!]` Note: `loop` was added to Ansible in version 2.5. It is not yet a full replacement for with_<lookup>, but it is recommend it for most use cases.

> `[!]` Note: `with_<lookup>` is NOT deprecated, and syntax will still be valid for the foreseeable future.

> `[!]` Note: `loop` syntax is not final - [thus keep up with docs](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html)

---

# `loop`

In most cases, loops work best with the `loop` keyword instead of `with_X` style loops.
The `loop` syntax is usually best expressed using filters instead of more complex use of `query` or `lookup`.


```yaml

hosts: all
vars:
  - packages:
    - git
    - build-essential
    - python3-poetry
become: True
tasks:
  - name: 
    package:
      name: "{{ item }}"
      state: latest
    loop:
      - packages
```
---

# Practice

- Create task with:
    - Variable list of users to be created
    - Use `user` module to create the user with loop
- Create new playbook:
    - Create another task:
        - User the same variable list
        - Use `user` module to delete same users
- [RTFM user module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html)

---

# Practice

```yaml
hosts: all
vars:
  - users:
    - alex
    - sharon
    - michael
    - karen

become: True
tasks:
  - name: Create user "{{ item }}"
    user:
      name: "{{ item }}"
      state: present
    loop:
      - users

  - name: Deleting user "{{ item }}"
    user:
      name: "{{ item }}"
      state: absent
    loop:
      - users

```
---

# `loop` with dictionary

#### `with_dict` substitution with `loop`

`with_dict` can be substituted by loop and either the `dictsort` or `dict2items` filters.

```yaml
hosts: all
vars:
  packages:
    pkg1: git
    pkg2: build-essential
    pkg3: python3-poetry
become: True
tasks:
  - name: Installing {{item.key}}
    package:
      name: "{{ item.value }}"
      state: latest
    loop: "{{packages | dict2items}}"
```

---

# Practice

- Create task with:
    - Variable list of users to be created with user name and comment with full name
    - Use `user` module to create the user with loop
    - Use loop with `dict2items` to serialize several  key value pairs
- Create new playbook:
    - Create another task:
        - User the same variable list
        - Use `user` module to delete same users
- [RTFM user module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html)

---

# Practice (cont.)

```yaml
hosts: all
vars:
  users:
    alex:
      full_name: "Alex M. Schapelle"
    sharon:
      full_name: "Sharon Kaufman"
    michael:
      full_name: "Michael Sepiashvili"
    karen:
      full_name: "Karen Kaufman"
become: True
tasks:
  - name: Create user "{{ item.key }}"
    user:
      name: "{{ item.key }}"
      state: present
      comment: "{{ item.value.full_name }}"
    loop:
      - "{{ users | dict2items }}"

  - name: Deleting user "{{ item.key }}"
    user:
      name: "{{ item.key }}"
      state: absent
      comment: "{{ item.value.full_name }}"
    loop:
      - "{{ users | dict2items }}"
```

---

# Practice (cont.)
Same can be achieved with `dictsort`
```yaml
  - name: Create user "{{ item.key }}"
    user:
      name: "{{ item.0 }}"
      state: present
      comment: "{{ item.1 }}"
    loop:
      - "{{ users | dictsort }}"
```
---

# `loop` with double dictionary

#### `with_subelements`

`with_subelements` is replaced by `loop` and the `subelements` filter.

```yaml
hosts: all
vars:
  users:
    - 
      - lastname: Schapelle
        members:
          - Alex
          - Sharon
      - lastname: Golan
        members:
          - Yoni

become: True
tasks:
  - name: Create user "{{ item.1 }}"
    user:
      name: "{{ item.1 }}"
      state: present
      comment: "{{ item.1 |  title }}  {{ item.0.lastname }}"
    loop:
      - "{{ users | subelements }}"
```

---

# Practice


- Create task with:
    - Variable list of users to be created with lastname key and comment with full name
    - Use `user` module to create the user with loop
    - Use loop with `subelements` to serialize items with 0 and 1 to show as key/value and their subelements
- Create new playbook:
    - Create another task:
        - User the same variable list
        - Use `user` module to delete same users
- [RTFM user module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html)


---

# `until`

Unlike `loop` and `with_<lookup>`, `until` is a the retry pattern that can be used with any action, in which you would prefer to perform a task until certain condition is met or amount of retries is reached.

for example :
- Lets create shell script that will print out random number within of range of 0 to 10
- lets create a taslk with until loop that will run this script on all hosts 100 times or until it reaches the output of 10 

```sh
#!/usr/bin/env bash 
echo $((1 + RANDOM % 10))
```

```yaml
- name: Run a script until we get 10
  script: random.sh
  register: result
  retries: 100
  until: result.stdout.find("10") != -1
  # default delay time is 5 seconds when not provided to playbook
  delay: 1
```

---

# Practice

- Write a task that will use `until` loop with 10 `retries` with `delay` of 10 second to implement an alive check for a webapp that is starting up.
- The web app can be accessed on `ansible_all_ipv4_addresses` on port 80 

```yaml
---
- 
  hosts: my-hosts
  tasks:
  - name: check webapp if it is up or not
    uri: 
      url=http://{{ ansible_all_ipv4_addresses }}:8080/alive return_content=yes
    register: result
    until: "result.content.find('OK') != -1"
    retries: 10
    delay: 10

```

