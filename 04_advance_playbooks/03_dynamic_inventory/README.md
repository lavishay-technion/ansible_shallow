
---

# Dynamic inventories

---

- The requirements of dynamic inventories
- How to Create dynamic inventories with minimal scripting
- How to interrogate a dynamic inventory
- Performance enhencements through the use of `_meta`
- The use of the Ansible Python framework for Dynamic Inventories

---

# Inventories

- We've used an inventory of hosts defined via out `ansible.cfg` and `hosts.ini`
- We have associated inventories variables both inline and via host_vars and group_vars directories
- An inventory can be specified and overridden on the command line using `-i` option

---

# Dynamic inventory key requirements

- Needs to be executable file. Can be written in any programming language that it can be executed from the command line
- Accepts command line options of `--list` and `--hosts` hostname
- Returns JSON encoded dictionary of inventory content when used with `--list`
- Returns a basic JSON encoded dictionary structure for `--host` hostname


---

# Example

- [inventory.py]()
- []()
