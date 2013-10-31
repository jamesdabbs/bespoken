# This role sets up a home media server, though there are still a few manual steps required:
#
# BOOT UP THE SERVER
# Duh. You may want to go ahead and set up the hostname and a static ip (and make
# sure the router is set up to forward ports appropriately).
#
# CREATE THE MEDIA AND STORAGE DIRECTORIES
# In the current iteration, /home is mounted on a different partition and $MEDIA is
# symlinked into there; $STORAGE is symlinked to an external drive.
#
# Mounting the storage drive may require an fstab entry similar to:
#
#     UUID=6ED2E7F9D2E7C405 /media/wind ntfs-3g defaults,windows_names,locale=en_US.utf8,uid=1001,gid=1001  0 0
#
#
# GET CHEF RUNNING
# Again, duh. But since you do this infrequently enough, remember to make sure the
# chef gem is up to date, purge the old jdabbs cookbook (\knife cookbook delete jdabbs)
# upload all the cookbooks (`berks upload`) and data bags and roles
# (`\knife (data bag / role) from file <bag> <item>`) and do something like
#
#    \knife bootstrap <address> --ssh-user ... \
#        --run-list "role[jdabbs::server]" --sudo
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

MEDIA   = "/data"
STORAGE = "/storage"

name        "server"
description "A bespoke home media server"
run_list    %w{
  jdabbs::default
  jdabbs::mirror
  samba::server
  openssh
  jdabbs::transmission
  jdabbs::flexget
  jdabbs::bitbucket
}
default_attributes({
  "jdabbs" => {
    "groups" => ["media"],
    "env" => {
      "MEDIA_DIR"   => MEDIA,
      "STORAGE_DIR" => STORAGE
    }
  },
  "mirror" => {
    "mailto"      => "james",
    "from"        => MEDIA,
    "to"          => "#{STORAGE}/mirrors/server",
    "directories" => {
      "music"     => "james",
      "podcasts"  => "james",
      "downloads" => "transmission"
    }
  },
  "samba" => {
    "workgroup"   => "WORKGROUP",
    "security"    => "share",
    "interfaces"  => "lo wlan0",
    "hosts_allow" => "10.0.0.0/8"
  },
  "openssh" => {
    "server" => {
      "permit_root_login"       => "no",
      "password_authentication" => "no",
      "allow_users"             => "james@10.0.0.* remote vagrant"
    }
  },
  "transmission" => {
    "user"     => "transmission",
    "settings" => {
      "download-dir"           => "#{MEDIA}/downloads",
      "incomplete-dir-enabled" => true,
      "watch-dir"              => "#{MEDIA}/downloads/.watch",
      "watch-dir-enabled"      => false,
      "rpc-username"           => "james",
      "rpc-password"           => "password",
      "rpc-whitelist"          => "127.0.0.1,10.0.*.*"
    }
  },
  "flexget" => {
    "user"  => "james",
    "feeds" => {
      "cbb" => {
          "accept_all" => true,
          "download" =>  "/data/podcasts/Comedy Bang! Bang!",
          "rss" => "http://feeds.feedburner.com/comedydeathrayradio"
      },
      "radiolab" => {
          "accept_all" => true,
          "download" => "/data/podcasts/Radiolab",
          "rss" => "http://feeds.wnyc.org/radiolab"
      },
      "tal" => {
          "accept_all" => true,
          "download" => "/data/podcasts/This American Life",
          "rss" => "http://feeds.thisamericanlife.org/talpodcast"
      }
    }
  },
  "bitbucket" => {
    "user"      => "james",
    "key_label" => "james@server"
  }
})

