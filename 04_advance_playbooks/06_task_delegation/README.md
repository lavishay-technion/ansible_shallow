
---

# Task delegation

---

# Task delegation

Ansible task delegation property or the keyword specified in the ansible-playbook is used to provide the control to run the task locally or to the other different hosts rather than running on the remote hosts specified on the inventory server list, and this can be the few tasks or running the entire play-book locally and also delegating facts to the local machines or the specific set of groups.

There are many playbooks in the projects that sometimes require to run tasks or the entire playbook on the local machine that hosts the inventory file or playbook, or we can say on the different remote hosts that are different from the remote hosts that are mentioned in the inventory list to run tasks  In that situation, we can use the `delegate_to` parameter so that the tasks can run locally.

---

# Example

we have the four tasks which will copy files from the ansible controller to the remote destination; in the second task, we will use the delegate_to parameter to get the URL status from the local or the delegated server only, and in the third task, we will get the output produced by the delegated task, and in the fourth task, ansible will reboot the remote machine.

- [Delegating to localhost](../../00_delegate.yaml)

