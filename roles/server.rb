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
# BOOTSTRAP THE NODE
# This is now documented in the `deploy` script
#
# CHECK ON THE WATCH DIR
# Optional, but the transmission watch dir is disabled by default so that it doesn't
# download the whole internets the first time that flexget runs. You probably want to
# manually run flexget once and then manually enable the watch dir. Note that transmission
# must be off when you do, since it writes over the config file when it shuts down.

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
  jdabbs::beets
  jdabbs::bitbucket
}
default_attributes({
  "jdabbs" => {
    "groups" => ["media"],
    "env" => {
      "MEDIA_DIR"   => MEDIA,
      "STORAGE_DIR" => STORAGE
    },
    "ssh" => {
      "allow_users" => "james@10.0.0.* remote vagrant"
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
    "workgroup"     => "WORKGROUP",
    "security"      => "share",
    "interfaces"    => "lo wlan0",
    "hosts_allow"   => "10.0.0.0/8",
    "guest_account" => "remote"
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
  "beets" => {
    "directory" => "#{MEDIA}/music"
  },
  "bitbucket" => {
    "user"      => "james",
    "key_label" => "james@server"
  }
})

