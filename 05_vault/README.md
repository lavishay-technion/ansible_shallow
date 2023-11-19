
---

# Ansible vault

<img src="../99_misc/.img/vault.png" alt="import include" style="float:right;width:400px;">

---

Usually at some point in developing ansible playbooks, there is a time, when someone asks regarding the sensitive information. That is when `ansible-vault` come into play. 

Lets see these vault features in action:

- Encrypt/decrypt variables
- Encrypting and decrypting files
- Re-Encrypting data
- Using multiple vaults

---

# Encrypt/decrypt variables

```sh
ansible-vault encrypt_string --ask-vault-pass --name 'ansible_become_pass' 'docker'
```
Once the prompt is provided, we can feed it a generic password, preferably not the same password as we are encrypting. I'll use  _vaultpass_ as password.
The output that we will get we can save at out variables or group_variables files and use it every time run the playbook
---

# Encrypt/decrypt files

Encrypting existing files is a quintessential application of Ansible vault, allowing users to secure pre-existing files containing sensitive data. The `ansible-vault encrypt` command is instrumental in this regard. It takes an already existing plain-text file and encrypts it, making the content secure and unreadable without the appropriate decryption password.

```sh
ansible-vault encrypt existing_file.yaml
```
Upon execution of this command, you'll be prompted to enter a new vault password, which will be used to encrypt the specified file.

Decrypting files is an essential operation when working with Ansible vault encrypted data. The ansible-vault decrypt command is used to revert encrypted files back to their plain text format, making them accessible for viewing or editing outside the vault-encrypted environment.
```sh
ansible-vault decrypt encrypted_file.yaml
```
Executing this command will prompt you for the vault password. Upon entering the correct password, the specified file will be decrypted, revealing its original plain text content.

Decryption should be handled with caution and typically performed when there is a necessity to edit, view, or share the file outside the Ansible vault environment. However, it's vital to minimize the time that sensitive data remains in an unencrypted state to mitigate potential security risks.

Execute the `ansible-vault decrypt` command targeting the desired encrypted file:

```sh
ansible-vault decrypt encrypted_file.yaml
```
Enter the correct vault password when prompted:

```sh
Vault password: ********
```
Ansible vault will decrypt the file, reverting it to its original plain text state, enabling further actions such as viewing or editing the sensitive content.

 
---

# Re-Encrypt data

Ansible vault encompasses a feature known as rekeying, enabled through the ansible-vault rekey command. Rekeying refers to the process of changing the password of an encrypted file without altering the content within the file itself. This feature is vital for maintaining the security and integrity of the encrypted data.

```sh
ansible-vault rekey encrypted_file.yaml
```
Executing this command prompts you for the current vault password, followed by the new password you wish to set. This changes the encryption key, effectively rekeying the file.

---

# Running Playbooks with Vaulted Files

#### Passing Vault Passwords

Executing playbooks that encompass Ansible vault encrypted files necessitates the passage of vault passwords. This enables Ansible to decrypt the vault-encrypted files during runtime, facilitating seamless playbook execution with the incorporated secure data.

#### Using --ask-vault-pass

The `--ask-vault-pass` option prompts you for the vault password interactively when running a playbook. It ensures that the necessary decryption key is available for decrypting any vault-encrypted files or variables used within the playbook.

```sh
ansible-playbook playbook.yaml --ask-vault-pass
```
Upon executing this command, you'll be prompted to enter the vault password, enabling the decryption of the vaulted content within the playbook execution process.

---

# Using Vault Password Files

Alternatively, vault password files can be used to pass the vault password non-interactively. This method involves specifying a file containing the vault password using the `--vault-id` or `--vault-password-file` option.

```sh
ansible-playbook playbook.yaml --vault-id /path/to/vault_password_file
```
#### Configuring `vault_password_file` in ansible.cfg

Locate or create the ansible.cfg file in your project directory or another appropriate location.

Edit the ansible.cfg file and specify the vault_password_file directive under the `[defaults]` section. Provide the path to your vault password file.

```ini
[defaults]
vault_password_file = /path/to/vault_password_file
```
Execute the playbook as you normally would. Due to the configuration, Ansible automatically knows where to find the vault password.
```sh
ansible-playbook playbook.yaml
```
By configuring the vault_password_file directive in the ansible.cfg, you're instructing Ansible to automatically use the specified file for the vault password when decrypting vault-encrypted data. This method eliminates the need to manually specify the vault password or password file each time you run a playbook, thereby enhancing efficiency and ease of use in managing Ansible vault encrypted content.

