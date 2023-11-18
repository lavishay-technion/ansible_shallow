
---

# Ansible import and include module

---

# Imports and include

<img src="../../99_misc/.img/import.png" alt="import include" style="float:left;width:400px;">

While working on complex playbooks on of the main thing to focus is not to rewrite existing code. This is where  the next list of modules comes in handy

- `include_tasks`: to include external tasks in side of your playbook
- `import_tasks` :  Import task to current playbook 
- Static Vs. dynamic : Difference between the 2 mentioned above

---

# `include` module

We can create separate yaml file which will only contain tasks using the YAML syntax which can be used inside a playbook by using `include` module.
Sadly, the module is going to be deprecated in future versions, yet, some part of it, mainly named `include_task` is preserved and still usable

---

# Example

- [Including task in a playbook](../../00_include_task.yaml)

---

# `import` module



---

# Example

- [Importing task in a playbook](../../01_import_task.yaml)

#### So what is the difference between `import_task` and `include_task` ?

---

# Static Vs. dynamic

Whenever we use `import_task` or `include_task`, we mostly will not  notice too much of the the difference, due to the execution precedence.
`import` module is pre-processed at the moment the playbook is parse (loaded into memory of the computer). Any playbook pre-loaded with data, is considered to that static value load to playbooks
`include` module is processed while the playbook is running, i.e after the playbook is already running. It is also known as dynamic value load of playbooks.

This is possible to see while using `when` condition on the tasks, during the run of the playbook

---

# Example

- [import task](../../02_import_task.yaml)
- [include task](../../03_include_task.yaml)
- [playbook that uses both of them](../../04_playbook.yaml)

---

# Practice

- Read the last example yaml files
- Run the main playbook file
- Check the differences
