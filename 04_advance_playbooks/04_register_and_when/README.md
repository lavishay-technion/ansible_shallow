
---

# Register and when

---

- How to register output, with the register directive
- How to use registered output
- How to work around differences with registered output
- Filters, that relate to registered content
- Utilising `when` with `register`

---

# Register

We usually run `ansible` command to test out infrastructure, for example:
```sh
ansible all -a 'hostname -s' -o
```
Yet, there are instances when we need to use the output to determine conclusion that `setup` module may not include
- [Saving hostname](../../00_register.yaml)

But saving output without checking it has not much value, thus combination of `register` keyword with `debug` module and `var` keyword. We can get the raw data or just accept the  `stdout` of the returned output
- [User registered data](../../01_reg_output.yaml)
- [User registered data with stdout](../../02_reg_stdout.yaml)

---

# Practice

---

# When 

In many cases, where we wish to use specific module, plugin or command on specific host and wish to check if host answer the criteria, we use `when` keyword
Many conditions can be avaluated with `and` and `or` boolean operators.
- [Setup Modules with when](../../03_setup_when.yaml)
- [Setup Module with when and `and`](../../04_setup_when_and.yaml)
- [Setup Module with when and `or` and `and`](../../05_setup_when_and_or.yaml)
- [Setup Module with when and `or` and `and`](../../06_setup_when_and_list.yaml)


---

# Practice


---

# When `register` and `when` meet

It's very usuful to combine `register` with `when` keyword, due to their benefitial nature. When working on systems, some of them dynamically can be updated, and those parameters may differe from env to env. In those scenarious ansible comes in handy

- [Registring when condition is triggered](../../07_register_when.yaml)
- [Registering only changed](../../08_register_changed.yaml)
- [Registering only when there `is` change](../../09_register_when_is_change.yaml)
- [Registering when there `is` skip](../../10_register_when_is_skip.yaml)


---

# Practice



