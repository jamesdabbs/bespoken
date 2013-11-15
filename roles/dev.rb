# This sets up a development environment. Besides the
# usual configuration, it:
#
# Sets up chef auto-checkin
# Installs rbenv and ruby_build
# Limits external ssh access
# Creates an ssh key
# Registers the key with bitbucket and github

name        "dev"
description "A development ready box"
run_list %{
  chef-client
  jdabbs::default
  rbenv::user
}

default_attributes({
  "rbenv" => {
    "user_installs" => {
      "user" => "james",
      "rubies" => []
    }
  }
})

