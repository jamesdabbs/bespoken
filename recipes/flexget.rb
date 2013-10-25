# Adapted from: https://github.com/chef-developers/chef-flexget

flexget = node["flexget"]
feeds   = flexget["feeds"]
u       = flexget["user"]
home    = "/home/#{u}"


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

# Yuck. See: http://stackoverflow.com/questions/14738364
class Chef::Node::ImmutableMash
  def to_h
    h = {}
    each do |k,v|
      h[k] = v.respond_to?(:to_h) ? v.to_h : v
    end
    h
  end
end

tasks = { "tasks" => feeds.to_h }
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

