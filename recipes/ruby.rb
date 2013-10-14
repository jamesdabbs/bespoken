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

# ruby build seems to need this, but defaults to install a non-findable version
package "libxml2-dev"

include_recipe "ruby_build"
include_recipe "rbenv::user"

