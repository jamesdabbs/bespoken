mirror = node["mirror"]

if mirror["create_dirs"]
  directory mirror["to"] do
    owner "mirror"
    group "mirror"
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

template "/usr/local/bin/mirror" do
  source "mirror.py.erb"
  owner  "mirror"
  group  "mirror"
  mode   0744
end

template "/var/spool/cron/crontabs/mirror" do
  source "mirror.crontab.erb"
  owner  "mirror"
  group  "crontab"
end

