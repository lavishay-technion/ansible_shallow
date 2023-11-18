
---

# Ansible tags

<img src="../../99_misc/.img/tags.png" alt="tags" style="float:left;width:400px;">

---

# Tags

Ansible tags are used to run only one or some specific tasks from a large playbook instead of running the whole playbook. Lets cover the topics of

- Using and execution of tags with playbooks
- Skip tags


---

# Using and execution of tags with playbooks

When using playbooks, usually the get large, thus it may be useful to run only specific parts of it instead of running the entire playbook. You can do this with Ansible tags. 
Using tags to execute or skip selected tasks is a two-step process:

- Add tags to your tasks, either individually or with tag inheritance from a block, play, role, or import.
- Select or skip tags when you run your playbook.

---

# Using and execution of tags with playbooks

To use tags we only need to add `tag` keyword to the playbook we use, and later use that playbook with `--tags` and the name of the tag we would wish to use. For example

- [Initial use](../../00.yaml) can be done as shown here with command `ansible-playbook 00.yaml --tags epel-install`
- We can also use [multiple tags](../../00.yaml) with separating tags with comma as shown:  `ansible-playbook 00.yaml --tags "epel-install,nginx-install"`

---

# Practice

- Create html with some unique quote in it.
- Add task with tag to copy  html file to nginx dedicated path
- Restart the nginx with tags

```sh
echo "Welcome to web app deployed by ansible" > index.html
```
---

# Practice (cont.)

```yaml
... # only showing relevant code that can be added to 00.yaml

- name: Copy html file to nginx
  copy:
    src: index.html
    dest: /usr/share/nginx/html/index.html
    mode: 644
  when: ansible_distribution == 'Debian'
  tags:
    - app-deploy
...
```

```sh
ansible-playbook 00.yaml --tags app-deploy
ansible-playbook 00.yaml --tags restart-nginx
```



---

# Skipping tags
To inverse the behavior of tags, or in other words to run everything that does not have tags we can use `--skip-tags`

```sh
ansible-playbook 00.yaml --skip-tags "app-deploy"
```
---

# Practice

- Run previous playbook skipping restart-nginx tag

```sh
ansible-playbook 00.yaml --skip-tags "restart-nginx"
```
