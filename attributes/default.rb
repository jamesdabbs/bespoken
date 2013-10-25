{
  "user"       => "transmission",
  "config_dir" => "/var/lib/transmission",
  "settings"   => {}
}.each { |k,v| node.default["transmission"][k] = v }

{
  "user"  => "james",
  "feeds" => {}
}.each { |k,v| node.default["flexget"][k] = v }

