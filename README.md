# jdabbs cookbook

... a work in progress.

TODO:

```
DATA FLOW
- port store script to python
- add tag (beet import things with music) scrip
- add script to pull music to local machine
Make scripts use paths from env variables

SAMBA
- security share?
- figure out user permissions and writability (may need mount / fstab)
Forward mail james -> gmail

FILE SERVER
make a simple app (flask? we've already got python ...) to
- allow browsing and file serving over HTTP
- run as a read-only user
- basic auth from data bag
- filter downloads dir

PLEX
use plexapp cookbook
configure ...
```


# Requirements

Several recipes will draw information from data bags which - for security's sake - aren't checked in.
Currently, those are the `james` and `remote` users.

View the `*.sample` data bags for a starting point for implmementing those.

TODO: split out auth data (not checked in) from stuff that recipes expect to be in data bags but that can
      still be in the repo

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
