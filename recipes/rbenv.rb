rbenv = node["jdabbs"]["rbenv"]

rubies = rbenv["rubies"]
global = rubies.first

node.set["rbenv"]["user_installs"] = [
  {
    "user"   => "james",
    "rubies" => rubies,
    "global" => global,
    "gems"   => Hash[ rubies.map { |r| [r, { "name" => "bundler" } ] } ]
  }
]

node.default["jdabbs"]["path"] = %{ $HOME/.rbenv/shims $HOME/.rbenv/bin } + node.default["jdabbs"]["path"]
node.default["jdabbs"]["zsh_plugins"] << "bundler"

include_recipe "ruby_build"
include_recipe "rbenv::user"

