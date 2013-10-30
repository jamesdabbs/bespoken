transmission = node["transmission"]


%w{ transmission transmission-cli transmission-daemon }.each do |pkg|
  package(pkg) { action :install }
end

template "/etc/default/transmission-daemon" do
  source "transmission-default.erb"
  mode 0644
end

template "/etc/init.d/transmission-daemon" do
  source "transmission-init-d.erb"
  mode 0755
end

service "transmission" do
  service_name "transmission-daemon"
  supports restart: true, reload: true
  action [:enable, :start]
end

directory "/var/lib/transmission" do
  owner transmission["user"]
end

settings = transmission["settings"]
settings.each do |k, dir|
  if k.to_s =~ /_dir$/ && settings["#{k}_enabled"]
    directory dir do
      owner transmission["user"]
    end
  end
end

file "#{transmission['config_dir']}/settings.json" do
  content JSON.pretty_generate transmission["settings"]
  notifies :reload, "service[transmission]", :immediate
end

