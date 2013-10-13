u = user "james"

node.projects.each do |name, conf|

  # Clone the project, creating a directory for it if needed
  path = conf["path"] || "src/#{name}"
  directory "#{u.home}/#{path}" do
    user      u.name
    group     u.name
    recursive true
  end

  git name do
    repository  conf["repository"]
    destination "#{u.home}/#{path}"
    action      :checkout
    user        u.name
  end

  # Copy over the tmuxinator config file
  directory "#{u.home}/.tmuxinator" do
    user  u.name
    group u.name
  end

  template "#{u.home}/.tmuxinator/#{name}.yml" do
    source ".tmuxinator/#{name}.yml"
    mode   0644
  end

end

