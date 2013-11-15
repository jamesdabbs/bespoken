def defaults *path, attrs
  d = path.reduce(node.default) { |d,p| d[p] }
  attrs.each { |k,v| d[k] = v }
end

defaults "transmission",
  "user"       => "transmission",
  "config_dir" => "/var/lib/transmission",
  "settings"   => {}

defaults "flexget",
  "user"  => "james",
  "feeds" => {}

defaults "jdabbs",
  "env"         => {},
  "path"        => [],
  "groups"      => [],
  "zsh_theme"   => "jdabbs",
  "zsh_plugins" => []

defaults "jdabbs", "ssh",
  "allow_users" => "james vagrant"

defaults "jdabbs", "rbenv",
  "rubies" => []

