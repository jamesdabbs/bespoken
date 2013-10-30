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

STORAGE_UUID = {
  toshiba_3tb: "6ED2E7F9D2E7C405",
}.fetch :toshiba_3tb

# -- User and directory setup -- #

include_recipe "users"
users_manage "media"

template "/home/remote/.ssh/rc" do
  source "remote-ssh.rc"
  mode   0640
end

# TODO:

# -- Samba -- #
# - security share?
# - figure out user permissions and writability (may need mount / fstab)
# Forward mail james -> gmail

# -- Data flow -- #
# Add to scripts repo:
# - tag (beet import)
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

