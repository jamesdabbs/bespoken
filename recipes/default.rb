include_recipe "users"
users_manage "james"

# node.set['authorization']['sudo']['users'] = james["id"]
# include_recipe "sudo"

# Copy over the various home config files
::Dir.foreach File.expand_path("../../templates/default/.rc/", __FILE__) do |f|
  next if f =~ /^\.+$/

  template "/home/james/#{f}" do
    source ".rc/#{f}"
    owner  "james"
    group  "james"
    mode   0644
  end
end

include_recipe "oh-my-zsh"

package "tree"

include_recipe "jdabbs::vim"

