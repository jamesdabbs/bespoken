u = user "james"

node.set["rbenv"]["user_installs"] = [
  {
    "user"   => u.name,
    "rubies" => ["2.0.0-p247"],
    "global" =>  "2.0.0-p247",
    "gems"   => [
      { "name" => "bundler"    },
      { "name" => "tmuxinator" }
    ]
  }
]
include_recipe "rbenv::user_install"

