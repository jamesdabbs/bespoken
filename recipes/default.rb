u = user "james"

include_recipe "users"
users_manage "sudo" # Creates from users/ data bag all users in the sudo group

# Set the timezone
tz = "US/Eastern"
execute "set timezone" do
  command %{ echo "#{tz}" | sudo tee /etc/timezone && sudo dpkg-reconfigure --frontend noninteractive tzdata }
  not_if { File.read("/etc/timezone") =~ /#{tz}/ }
end

# Copy over the various home config files
::Dir.foreach File.expand_path("../../templates/default/.rc/", __FILE__) do |f|
  next if f =~ /^\.+$/

  template "#{u.home}/#{f}" do
    source ".rc/#{f}"
    owner  u.name
    group  u.name
    mode   0644
  end
end

# TODO: update plugins, theme (?)
include_recipe "oh-my-zsh"
unless true # ::File.read("#{home}/.zshrc") =~ /\.zshrc\.local/
  ::File.open "#{u.home}/.zshrc", 'a' do |f|
    f.puts <<-EOS
      # Add global rbenv paths
      export PATH=/opt/rbenv/shims:/opt/rbenv/bin:$PATH

      # Add local zshrc
      source $HOME/.zshrc.local
    EOS
  end
end

package "tree"

include_recipe "jdabbs::tmux"
include_recipe "jdabbs::vim"

include_recipe "jdabbs::projects"

