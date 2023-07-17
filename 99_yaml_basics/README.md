
---

# YAML: Yet Another Markup Language

.footer: Created By Alex M. Schapelle, VAioLabs.io

---

# YAML: A Breakdown

- We'll go through some topics such as:
    - What is YAML and Syntax basics?
        - Is YAML yet another markup language.... really?(Hint:it'snot)
        - Tabs or spaces ? There is only correct answer.
    - Mappings ,Sequences, Scalars, Collections
    - Defining data types and their functions in YAML.
        - Using Syntax to create “collection” of data.
        - Structure, Comments, Tags, Anchors.
    - Putting all your documents in one stream.
        - Just how human-readable can YAML?
 - "Natural and meaningful".
 - AKA Human readable.

---

# YAML relies on the familiar

- Works with "agile" languages:
    - Python, Perl, Ruby, etc.
    - Common data types:
        - Scalars,lists,arrays.
        - Common at a structures:
            -   Indentations, dashes, colons
        - Common uses:
            - Config files.
            - Storing Data.

---

# YAML Goals in order:

- Easily human-readable
- Portable 
- Matches native data structures to agile languages
- Consistent and able to support generic tools
- One-Pass processing
- Expressive and extensible
- Easy to implement and use

---

# YAML Syntax

- Initially designed for Humans > than for Computes:
- Spaces, **NOT** tabs.(No-not like in Python)
- Indent for structure.
- Dashes for lists.
- Colons for key-values.

---

# YAML Syntax Example

```yaml
host: ils_lnx-10
datacenter: 
    - location: ils 
      cab: 9
      roles:
        - web
        - db
```
- NOTE: you can NOT use tabs to indent yaml files.
- ONLY spaces

---

# YAML Syntax 

Character support:

- Printable Unicode.
- Unsupported symbols:
    - C0/C1 blocks:
    - Exceptions
        - Tab
        - Line feeds
        - Carriage return.
        - Delete.
        - Next line
    - Encoding:
        - UTF-8
        - UTF-16 
        - UTF-32:
            - Mandatory for JSON compatibility.

--- 

# YAML form styles

There are several styles writing YAML files

- Block or Flow:
    - Block-Styles:
        - Better for humans.
        - Less compact.
    - Flow-Styles:
        - An extension of JSON
        - “Folding” long lines of content.
        - tags and anchors.

---

# YAML Style Examples

- Block-style:

```yaml
hosts: ils_lnx-101
datacenter:
    location: ils 
    cab: 9
    roles:
        - web 
        - db

```

---

# YAML Style Examples 

- Flow-style:

```yaml
hosts: "ils_lnx-101"
datacenter: {      location: ILS , cab: 13   } 
roles: [     web,     db       ]
```

> Note: Please notice the spaces and indents( in example they are exaggerated to emphasize the space)

---

# YAML Mappings


- Mappings:
    Associative arrays, hash-tables, key-value pairs, collections.
- Denoted with a colon and a space-->(:)
- No duplicate keys.
- Mappings can be nested.
- Flow-styles:
    - Use curly brackets and commas

--- 

# Mappings Example

```yaml
- id: 1
  name: Franc
- id: 2
  name: Joh

```
Suppose you have a have nested array of objects which has array of strings for one of the property

```yaml
- id: 1
  name: Franc
  roles:
  - admin
  - hr
- id: 2
  name: John
  roles:
  - admin
  - finance
```
---

# YAML Sequences

Sequences:

- Lists, arrays, collections
- Denoted with a dash and a space(-)
- Can be combined with mappings:
    - "Mappings of sequences"
    - "Sequences of mappings"
- Can NOT be:
    - Blank
    - Nested without mapping

---

# YAML Sequences Example

```yaml
key1:
  - value1
  - value2
  - value3
  - value4
  - value5

```
The same above can alternatively represented using square brackets syntax in single line :

```yaml

key1: [value1,value2,value3,value4,value5]

```
---

# YAML Scalars

- Scalar is an abstract storage location paired with an associated symbolic name, which contains some known or unknown quantity of information referred to as a value( essentially "sort of" data type that holds various types in it.)
    - String: can be used with'or",just remember that "allows escape characters
    - Number: any type would be fine.
    - Boolean: True or False.
    - White space is permitted
- Use quotes to convert an on string scalar into a string scalar.

---

# YAML Structure

Multiple directories/documents-in-one-file:

- Optional within YAML spec
- Maybe are requirement for different platform
- Triple dashes(---)to mark the star of file
- Triple dots(...)to mark the end without closing the data stream(they are optional for ansible but essential for kubernetes,thus all depends on what platform you are running on.)


---
# YAML Structure Example

- Stream with Triple dot end Example:
```yaml
---       #   <- Please mention the triple dashes that signify that start of the file
- hosts: ils_lnx-101
  datacenter: 
    - location: ils 
    - cab: 9
    - roles:
        - web 
        - db

...     # <- Please mention the triple dots that signify that start of the file
---     # <- Please mention the triple dashes that signify that start of the file
- hosts: ils_lnx-102
  datacenter:
    location: ils
    cab: 21
    roles:
        - app
        - queue
```
---

# YAML Comments

- In YAML hash tag signifies comment.
    - Just like in Bash or Python.
- Comments can be place on their own line.
- Blank lines work as comment delimiters as well.   

---

# YAML Tags
- Tags provide us with three functions:
    - The ability to assign a universal resource indicator(URI).(%TAG)
    - The ability to assign local tags to that indicator.(!ILS)
    - The ability to change how the YAML parser reads certain scalars when processing the YAML itself.

- !! Indicator to change the data type of a scalar:
    - Default data types:
        - `seq`: Sequence
        - `map`: Map
        - `str`: String
        - `int`: Integer
        - `float`: Floating-point-decimal
        - `null`: Null
        - `binary`: Binary code
        - `omap`: Ordered map
        - `set`: Unordered set

---

# YAML Anchors

- Anchors allow us to reuse data across an YAML file. Have a list or scalar that needs to be referenced again and again?
- With anchor,we can use the `&` prefix to assign some data a name, then use the `*` with that name to call it repeatedly throughout the file,making updating large files a quick and easy process.

---

# Conclusion

- YAML is great language to know for various systems and as of now (2018+)
- It's going to be introduced to be part of Linux Network Manager/daemon, Ansible,K8s and so on.

---

# Practice

Creating yaml file called `mydetails.yml`:

- Creating mapping and sub-mappings with your details
    - your name
    - last name
    - hobbies, more than 1
    - favorite foods, more than 3
