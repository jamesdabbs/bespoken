# Sets up a script and cron job to mirror media directories onto
# the storage location
#
# Note: this is currently running as "james" since storage is an
# ntfs drive mounted as "james" and rsyncing onto that drive by
# another user is problematic. Otherwise it would be reasonable to
# have a dedicated mirror user.

mirror = node["mirror"]

if mirror["create_dirs"]
  directory mirror["to"] do
    owner "james"
    group "james"
    recursive true
  end

  mirror["directories"].each do |dir, usr|
    directory "#{mirror['from']}/#{dir}" do
      owner usr
      group "media"
      recursive true
    end
  end
end

bin = "/usr/local/bin/mirror"

template bin do
  source "mirror.py.erb"
  owner  "james"
  group  "james"
  mode   0744
end

cron "mirror" do
  minute  "0"
  hour    "2"
  user    "james"
  command "#{bin} > /dev/null"
end

