MEDIA   = "/data"
STORAGE = "/storage"


name        "server"
description "A bespoke home media server"
run_list    %w{
  jdabbs::default
  jdabbs::server
  jdabbs::mirror
  samba::server
  openssh
  jdabbs::transmission
  jdabbs::flexget
  jdabbs::bitbucket
}
default_attributes({
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
    "hosts allow" => "10.0.0.0/8"
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

