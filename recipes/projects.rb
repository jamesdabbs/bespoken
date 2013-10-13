james = data_bag_item "users", "james"

node.projects.each do |name, conf|
  username = conf["user"] || "james"
  user = data_bag_item "users", username
  home = user["home"] || "/home/#{user["id"]}"

  # Clone the project, creating a directory for it if needed
  path = conf["path"] || "src/#{name}"
  directory "#{home}/#{path}" do
    user      user["id"]
    group     user["id"]
    recursive true
  end

  git name do
    repository  conf["repository"]
    destination "#{home}/#{path}"
    action      :checkout
    user        user["id"]
  end

  # Copy over the tmuxinator config file
  directory "#{home}/.tmuxinator" do
    user  user["id"]
    group user["id"]
  end

  template "#{home}/.tmuxinator/#{name}.yml" do
    source ".tmuxinator/#{name}.yml"
    mode   0644
  end

end

