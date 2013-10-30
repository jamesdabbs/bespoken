# Creates an ssh key and registers it with BitBucket
# Adapted from: http://clarkdave.net/2013/02/send-deploy-keys-to-bitbucket-in-a-chef-recipe/
bitbucket = node["bitbucket"]


u = data_bag_item "users", bitbucket["user"]

chef_gem 'httparty' do
  version '0.11.0' # Getting multijson conflicts otherwise
end

execute 'generate ssh key for james' do
  user     'james'
  creates  '/home/james/.ssh/id_rsa'
  command  'ssh-keygen -t rsa -q -f /home/james/.ssh/id_rsa -P ""'
  notifies :create, "ruby_block[add_ssh_key_to_bitbucket]"
  notifies :run, "execute[add_bitbucket_to_known_hosts]"
end

execute "add_bitbucket_to_known_hosts" do
  action  :nothing # only run when ssh key is created
  user    'james'
  command 'ssh-keyscan -H bitbucket.org >> /home/james/.ssh/known_hosts'
end

ruby_block "add_ssh_key_to_bitbucket" do
  action   :nothing # only run when ssh key is created
  block do
    require 'httparty'

    url      = "https://api.bitbucket.org/1.0/users/jamesdabbs/ssh-keys"
    response = HTTParty.post(url, {
      basic_auth: {
        username: u["bitbucket_username"],
        password: u["bitbucket_password"]
      },
      body: {
        accountname: u["bitbucket_username"],
        label:       bitbucket["key_label"],
        key:         File.read('/home/james/.ssh/id_rsa.pub')
      }
    })

    unless response.code == 200 or response.code == 201
      Chef::Log.warn("Could not add james key to Bitbucket, response: #{response.body}")
      Chef::Log.warn("Add the key manually:")
      Chef::Log.info(File.read('/home/james/.ssh/id_rsa.pub'))
    end
  end
end

u["bitbucket_repos"].each do |repo, path|
  git repo do
    repository  repo
    destination path
    action      :nothing
    subscribes  :checkout, "ruby_block[add_ssh_key_to_bitbucket]"
    user        bitbucket["user"]
  end
end

