include_recipe "users"
users_manage "james"

james = data_bag_item "users", "james"

# TODO: figure out why this seems to break future provisioning runs
# node.set['authorization']['sudo']['users'] = james["id"]
# include_recipe "sudo"

# Set the timezone
tz = "US/Eastern"
execute "set timezone" do
  command %{ echo "#{tz}" | sudo tee /etc/timezone && sudo dpkg-reconfigure --frontend noninteractive tzdata }
  not_if { File.read("/etc/timezone").strip == tz }
end

# Copy over the various home config files
home = james["home"] || "/home/james"
::Dir.foreach File.expand_path("../../templates/default/.rc/", __FILE__) do |f|
  next if f =~ /^\.+$/

  template "#{home}/#{f}" do
    source ".rc/#{f}"
    owner  "james"
    group  "james"
    mode   0644
  end
end

# TODO: update to include
# - Personalized theme (?)
# - Extra plugins
# - Source .zsh_aliases and .zshrc.local
#   - Extract other .zshrc changes into .zshrc.local
include_recipe "oh-my-zsh"

package "tree"

include_recipe "jdabbs::tmux"
include_recipe "jdabbs::vim"

