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

node.default["jdabbs"]["path"] = %{ $HOME/.rbenv/shims $HOME/.rbenv/bin } + node.default["jdabbs"]["path"]
node.default["jdabbs"]["zsh_plugins"] << "bundler"

include_recipe "ruby_build"
include_recipe "rbenv::user"

