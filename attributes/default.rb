{
  "user"       => "transmission",
  "config_dir" => "/var/lib/transmission",
  "settings"   => {}
}.each { |k,v| node.default["transmission"][k] = v }

{
  "user"  => "james",
  "feeds" => {}
}.each { |k,v| node.default["flexget"][k] = v }

{
  "env"         => {},
  "path"        => [],
  "groups"      => [],
  "zsh_theme"   => "jdabbs",
  "zsh_plugins" => []
}.each { |k,v| node.default["jdabbs"][k] = v }

