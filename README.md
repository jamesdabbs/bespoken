# jdabbs cookbook

... a work in progress.

# Requirements

The `users` setup looks for users in data bags. Those are not checked in (for security's sake)
but should look something like:

```
{
  "id":         "james" ,
  "password":   ... ,
  "shell":      "\/bin\/zsh ,
  "groups":    ["sudo", "rbenv"],
  "ssh_keys":  [ ... ]
}
```

Use `openssl passwd ...` to generate the password hash, as detailed here: https://github.com/opscode-cookbooks/users.

It is important that the user be in the "sudo" group - both to have sudo access, and because members of this group are automatically created from entries in the users data bag.

# Usage

Some useful commands:

```
$ vagrant up               # start the box
$ vagrant provision        # run chef-solo
$ vagrant ssh              # ssh into the default user
$ vagrant ssh -- -l james  # ssh in as `james`
```

# Attributes

# Recipes

# Author

Author:: James Dabbs (jamesdabbs@gmail.com)
