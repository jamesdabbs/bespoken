# jdabbs cookbook

... a work in progress.

# Requirements

The `users` setup looks for users in data bags. Those are not checked in (for security's sake)
but should look something like:

```
{
  "id":         "james" ,
  "bitbucket_repos": {
    <git uri>: <clone path>,
    ...
  }
  "password":   <password hashed with `openssl passwd`>, # See: https://github.com/opscode-cookbooks/users.
  "shell":      "\/bin\/zsh" ,
  "groups":    ["sudo", ...], # Needed both for sudo access, and for the default recipe to create this user
  "ssh_keys":  [ ... ],
  "smbpasswd":  <plain text password>
}
```

Server setup also expects a remote user:

```
{
  "id":       "remote",
  "groups":   ["media"],
  "ssh_keys": [ ... ]
}
```

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
