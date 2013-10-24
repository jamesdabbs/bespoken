u = user "james"

edge = "2.0.0-p247"

node.set["rbenv"]["user_installs"] = [
  {
    "user"   => u.name,
    "rubies" => [edge],
    "global" => edge,
    "gems"   => {
      edge => [
        { "name" => "bundler"    },
        { "name" => "tmuxinator" }
      ]
    }
  }
]

# Ruby build was failing to find an appropriate libxml2-dev without this
execute "sudo apt-get update -y"

include_recipe "ruby_build"
include_recipe "rbenv::user"

