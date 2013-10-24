u = user "james"

include_recipe "users"
users_manage "sudo" # Creates from users/ data bag all users in the sudo group

# Set the timezone
tz = "US/Eastern"
execute "set timezone" do
  command %{ echo "#{tz}" | sudo tee /etc/timezone && sudo dpkg-reconfigure --frontend noninteractive tzdata }
  not_if { File.read("/etc/timezone") =~ /#{tz}/ }
end

include_recipe "oh-my-zsh"

%w{ .ackrc .gemrc .gitconfig .gitignore_global .rspec .tmux.conf .vimrc
    .zsh_aliases .zshrc .zshrc.local jdabbs.zsh-theme }.each do |f|
  template "#{u.home}/#{f}" do
    source ".rc/#{f}"
    owner  u.name
    group  u.name
    mode   0644
  end
end

package "tree"

include_recipe "jdabbs::tmux"
include_recipe "jdabbs::vim"

