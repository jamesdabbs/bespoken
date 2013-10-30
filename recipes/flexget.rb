# Adapted from: https://github.com/chef-developers/chef-flexget

flexget = node["flexget"]
u       = flexget["user"]
home    = "/home/#{u}"

dbu     = data_bag_item "users", u
dbfeeds = dbu["feeds"] || {}

feeds = flexget["feeds"].merge dbfeeds


include_recipe "python"

python_pip "flexget" do
  action :install
end

directory "#{home}/.flexget" do
  owner u
  group u
end

feeds.each do |name, conf|
  if dir = conf["download"]
    directory dir do
      owner u
      group u
    end
  end
end

def hashify obj
  if obj.respond_to? :to_hash
    h = {}
    obj.to_hash.each do |k,v|
      h[k] = hashify v
    end
    h
  else
    obj
  end
end

tasks = { "tasks" => hashify(feeds) }
file "#{home}/.flexget/config.yml" do
  owner   u
  group   u
  content tasks.to_yaml
end

cron "flexget" do
  minute  "*/15"
  user    u
  command "/usr/local/bin/flexget --cron"
end

