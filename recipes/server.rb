# This recipe sets up a home media server, though there are still a few manual steps required:
#
# BOOT UP THE SERVER
# Duh. You may want to go ahead and set up the hostname and a static ip (and make
# sure the router is set up to forward ports appropriately).
#
# CREATE THE MEDIA AND STORAGE DIRECTORIES
# In the current iteration, /home is mounted on a different partition and $MEDIA is
# symlinked into there; $STORAGE is symlinked to an external drive.
#
# GET CHEF RUNNING
# Again, duh. But since you do this infrequently enough, remember to make sure the
# chef gem is up to date, upload all the cookbooks (`berks upload`) and data bags
# (`\knife data bag from file <bag> <item>`) and do something like
#
#    \knife bootstrap <address> --ssh-user ... --ssh-password \
#        --run-list "recipe[jdabbs::server]" --sudo
#
# The \knife signifies to use the local knife version, since system knife may be old
# (likely the problem if you see missing constant errors in weird places).
#
# You'll need to already have ssh running on the target box (`apt-get openssh-server`),
# but this will overwrite the existing settings.
#
# CHECK ON THE WATCH DIR
# Optional, but the transmission watch dir is disabled by default so that it doesn't
# download the whole internets the first time that flexget runs. You probably want to
# manually run flexget once and then add `flexget_checked` to the node's attributes.
#
# DOWNLOAD SCRIPTS
# Again, optional, but there are several useful manual scripts in a private Bitbucket
# repo that is intended to live at ~/scripts

MEDIA   = "/data"
STORAGE = "/storage"

STORAGE_UUID = {
  toshiba_3tb: "6ED2E7F9D2E7C405",
}.fetch :toshiba_3tb


include_recipe "jdabbs::default"
u = user "james"


# -- User and directory setup -- #

include_recipe "users"
users_manage "media"

if node["server"]["vm"]
  # We're building test vms. Go ahead and create the base dirs and
  # make sure apt is up to date
  [MEDIA, STORAGE].each do |dir|
    directory dir do
      group "media"
      mode   0775
      recursive true
    end
  end

  execute 'sudo apt-get update -y'

else
  # This is a live environment. Directories and updates should be
  # managed manually (for now)

  # This is largely intended to be sure that STORAGE exists
  directory "#{STORAGE}/mirrors" do
    user  "mirror"
    group "media"
  end
end


{
  "music"     => "james",
  "podcasts"  => "james",
  "downloads" => "transmission",
}.each do |name, owner|
  directory "#{MEDIA}/#{name}" do
    user  owner
    group "media"
  end
end

template "/home/remote/.ssh/rc" do
  source "remote-ssh.rc"
  mode   0640
end

# TODO: the sections that recipe + node config should probably be
#       extracted to a role.

# -- Mirrors -- #
defaults "mirror",
  "to"          => "#{STORAGE}/mirrors/server",
  "directories" => %w{ music podcasts downloads }.map { |dir| "#{MEDIA}/#{dir}" },
  "mailto"      => "james"
include_recipe "jdabbs::mirror"

# -- Mail -- #
# TODO: send externally?
package "mailutils"

# -- Samba shares (from data bag) -- #
# TODO:
# - security share?
# - figure out user permissions and writability (may need mount / fstab)
defaults "samba",
  "workgroup"   => "WORKGROUP",
  "security"    => "share",
  "interfaces"  => "lo wlan0",
  "hosts allow" => "10.0.0.0/8"
include_recipe "samba::server"

# -- SSH -- #
defaults "openssh", "server",
  "permit_root_login"       => "no",
  "password_authentication" => "no",
  "allow_users"             => "james@10.0.0.* remote vagrant"
include_recipe "openssh"

# -- Transmission -- #
defaults "transmission", "settings",
  "download-dir"           => "#{MEDIA}/downloads",
  "incomplete-dir-enabled" => true,
  "watch-dir"              => "#{MEDIA}/downloads/.watch",
  "watch-dir-enabled"      => node[:flexget_checked]||false,
  "rpc-username"           => "james",
  "rpc-password"           => u.transmission_password,
  "rpc-whitelist"          => "127.0.0.1,10.0.*.*"
include_recipe "jdabbs::transmission"

# -- Flexget -- #
defaults "flexget",
  "user"  => "james",
  "feeds" => u.feeds
include_recipe "jdabbs::flexget"


# TODO:

# -- Data flow -- #
# Add to scripts repo:
# - tag (beet import)
# - store (taggart)
# - sync_music
# Make scripts use env variables, added in .zshrc.local
# Split .zshrc.user & .zshrc.local
# Advanced: generate a per-box ssh key and automatically register w/ Bitbucket

# -- File server -- #
# make a simple app (flask? we've already got python ...) to
# - allow browsing and file serving over HTTP/:80
# - run as a read-only user
# - basic auth from data bag
# - filter downloads dir

# -- Plex / roku -- #
# use plexapp cookbook
# configure ...

