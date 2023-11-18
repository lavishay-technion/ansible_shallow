
---

# Blocks

---

Ansible Block and Rescue are powerful features in Ansible, which are used for grouping tasks and handling errors in playbooks. They offer an efficient way to manage complex automation scripts, making them more readable, maintainable, and resilient to failures.

- Grouping tasks with blocks
- Handling errors with blocks


---

# Grouping tasks with blocks

An Ansible Block is a mechanism to group multiple tasks together in an Ansible playbook. The primary purpose of a block is to create logical groupings of tasks, which can be treated as a single unit. This is particularly useful for organizing complex playbooks by breaking them down into smaller, more manageable parts.

- [Example](../../00_block.yaml)

---

# Practice

- Run the example playbook on web hosts
- Change the web hosts to all hosts
- Why is error happening ?

---

# Handling errors with blocks

To handle errors ansible uses `rescue`. It specifies a set of tasks that should be executed if an error occurs in any of the tasks within a block. The rescue section is akin to an exception handling mechanism found in many programming languages

- [Example](../../01_rescue.yaml)

---

# Practice

- Read the rescue yaml example
- Run the the file
- Compare the block and rescue files
- What's the difference

