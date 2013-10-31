# Basic setup for all of my chef-managed boxes

# For OSX compatibility
link "/home" do
  to     "/Users"
  not_if { ::Dir.exists? "/home" }
end


include_recipe "users"

groups = ["sudo", "remote"] + node["jdabbs"]["groups"]
groups.each { |g| users_manage g }

directory "/home/remote/.ssh" do
  owner "remote"
  group "remote"
end
template "/home/remote/.ssh/rc" do
  source  "remote-ssh.rc"
end


# Set the timezone
tz = "US/Eastern"
execute "set timezone" do
  command %{ echo "#{tz}" | sudo tee /etc/timezone && sudo dpkg-reconfigure --frontend noninteractive tzdata }
  not_if { File.read("/etc/timezone") =~ /#{tz}/ }
end

# TODO: set theme and plugins
include_recipe "oh-my-zsh"

template "/home/james/.zshrc" do
  source ".rc/.zshrc.erb"
  owner  "james"
  group  "james"
end

file "/home/james/.zshrc.local" do
  content "# Make any local rc changes here"
  owner   "james"
  group   "james"
  action  :create_if_missing
end

template "/home/james/.oh-my-zsh/themes/jdabbs.zsh-theme" do
  source ".rc/jdabbs.zsh-theme"
  owner  "james"
  group  "james"
end

%w{ .ackrc .gemrc .gitconfig .gitignore_global .rspec .tmux.conf .vimrc
    .zsh_aliases }.each do |f|
  template "/home/james/#{f}" do
    source ".rc/#{f}"
    owner  "james"
    group  "james"
  end
end

execute "sudo apt-get update -y"
package "mailutils"
package "tree"

include_recipe "jdabbs::tmux"
include_recipe "jdabbs::vim"

