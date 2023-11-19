
---

# Ansible Advance Execution


---

# Extending view on variables

We'll go over examples of variables use and expand on the knowledge we just got from previous encounter.

- [simple use](../04_advance_playbooks/00_variables/00_simple.yaml)
- [dictionary variable](../04_advance_playbooks/00_variables/01_dict.yaml)
- [named_list](../04_advance_playbooks/00_variables/02_named_list.yaml)
- [variables in external variable file](../04_advance_playbooks/00_variables/03_extenal.yaml)
- [prompting user](../04_advance_playbooks/00_variables/04_prompt.yaml)
- [hostvar usage](../04_advance_playbooks/00_variables/05_hostvar_use.yaml)


---

# Practice

- Create folder vars
- Create in vars folder yaml file called  `details.yaml`
    - Set key value pairs of:
        - username with your username
        - list of songs/artist/books that you like
        - dictionary of your family members( your_family: you, wife, kids, girlfriend, parents: father, mother, siblings)
- Create playbook that includes vars in it and displays them with debug module

---

# Practice (cont.)

```sh
mkdir vars
touch vars/details.yaml
```

```yaml
username: silent-mobius

list_of_songs:
    - "livin la vida loca"
    - "no scrubs"
    - "black magic woman"
    - smooth
    - "all eyes on me"
    - "ghetto gospel"

- family
  lastname: Schapelle
    name:
        Alex
        Sharon
  lastname: Kaufman
    name:
        Orit
        Ehud
        Gal
```
---

# Practice (cont.)

```yaml
---

- 

  hosts: db
  gather_facts: False
  vars:
    - vars/details.yaml
  tasks: 
    - name: Print the variables
      debug:
        msg: "{{ username }} {{ list_of_songs }} {{ family }}"
```