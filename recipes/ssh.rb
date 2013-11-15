ssh = node["jdabbs"]["ssh"]

# Configure the ssh server
{
  "permit_root_login"       => "no",
  "password_authentication" => "no",
  "allow_users"             => ssh["allow_users"]
}.each { |k,v| node.set["openssh"][k] = v }
include_recipe "openssh"

# Create an ssh key
# Upload the key to github, bitbucket, if given credentials
# (add both to known hosts)

