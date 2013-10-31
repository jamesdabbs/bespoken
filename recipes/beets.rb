include_recipe "python"

python_pip "beets"

directory "/home/james/.config/beets" do
  owner "james"
  group "james"
  recursive true
end

template "/home/james/.config/beets/config.yml" do
  source "beets-config.yml.erb"
  owner  "james"
  group  "james"
end

