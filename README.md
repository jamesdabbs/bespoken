# jdabbs cookbook

... a work in progress.

TODO:
* Install / configure:
  * tmuxinator
* set up symlinks to config files for non-chef environments
* use data bag for user configs in recipes
* figure out why `sudo` recipe breaks future provision runs
* fix timezone

# Requirements

The `users` setup looks for users in data bags. Those are not checked in (for security's sake)
but should look something like:

```
{
  "id":         ... ,
  "password":   ... ,
  "shell":      ... ,
  "groups":   [ ... ],
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
