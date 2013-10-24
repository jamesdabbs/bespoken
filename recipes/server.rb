# This recipe sets up a home media server, though there are still a few manual steps required:
#
# BOOT UP THE SERVER
# Duh
#
# CREATE THE MEDIA AND STORAGE DIRECTORIES
# In the current iteration, /home is mounted on a different partition and /data is
# symlinked into there; /storage is symlinked to /media/Wind.
MEDIA   = "/data"
STORAGE = "/storage"

# VERIFY YOU HAVE A FLEXGET CONFIG TEMPLATE
# There is a sample template in the repo, but the actual one is likely to contain
# passkeys or other sensitive data (TODO: encrypted data bag this)
#
# GET CHEF RUNNING
# Again, duh. But since you do this infrequently enough, remember to make sure the
# chef gem is up to date, upload all the cookbooks (`berks upload`) and data bags
# (`\knife data bag from file <bag> <item>`) and do something like
#
#    knife bootstrap <address> --ssh-user ... --ssh-password ... \
#        --run-list "recipe[jdabbs::server]" --sudo
#
# CHECK ON FLEXGET
# It gets a little overzealous downloading Radiolab's back catalog sometimes ...


include_recipe "jdabbs::default"
u = user "james"


# -- User and directory setup -- #

include_recipe "users"
users_manage "media"

# This is largely intended to be sure that STORAGE exists
directory "#{STORAGE}/mirrors" do
  user  "mirror"
  group "media"
  mode  0755
end

{
  "music"     => "james",
  "podcasts"  => "james",
  "downloads" => "transmission",
}.each do |name, owner|
  directory "#{MEDIA}/#{name}" do
    user  owner
    group "media"
    mode  0755
  end
  directory "#{STORAGE}/mirrors/server/#{name}" do
    user  "mirror"
    group "media"
    mode  0755
    recursive true
  end
end


# -- Samba shares (from data bag) -- #

execute 'sudo apt-get update -y'
include_recipe "samba::server"


# -- SSH -- #
# TODO: Customize motd
include_recipe "openssh"
{
  "permit_root_login"       => "no",
  "password_authentication" => "no",
  "allow_users"             => "james@10.0.0.* remote vagrant"
}.each { |k,v| node.default["openssh"]["server"][k] = v }


# -- Transmission -- #

include_recipe "transmission"

directory "#{MEDIA}/downloads/.watch" do
  user  "james"
  group "media"
  mode  0755
end

{
  "download_dir"           => "#{MEDIA}/downloads",
  "incomplete_dir_enabled" => true,
  "watch_dir"              => "#{MEDIA}/downloads/.watch",
  "watch_dir_enabled"      => true,
  "rpc_username"           => "james",
  "rpc_password"           => u.transmission_password
}.each { |k,v| node.default["transmission"][k] = v }

# -- Flexget -- #
# Adapted from: https://github.com/chef-developers/chef-flexget

include_recipe "python"

%w{ flexget transmissionrpc }.each do |package|
  python_pip(package) { action :install }
end

directory "#{u.home}/.flexget" do
  user  "james"
  group "james"
  mode  0755
end

u.feeds["tasks"].each do |name, conf|
  if dir = conf["download"]
    directory dir do
      user  "james"
      group "james"
      mode  0755
    end
  end
end

file "#{u.home}/.flexget/config.yml" do
  user    "james"
  group   "james"
  content u.feeds.to_yaml
end

# TODO: verify that this is okay, and then add it
# cron "flexget" do
#   hour    "*/15"
#   user    "james"
#   command "/usr/local/bin/flexget --cron"
# end

# -- Mirrors -- #
# TODO: script to sync downloads, music, podcasts -> storage
# TODO: tagging tools
# TODO: start transmission on boot

# -- Mail -- #
# TODO: set up on remote logins, mirror / flexget failures
package "mailutils"

