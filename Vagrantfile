# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure "2" do |config|
  config.vm.box     = "ubuntu-server-10044-x64-vbox4210-nocm.box"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210-nocm.box"

  config.omnibus.chef_version     = :latest
  config.berkshelf.enabled        = true
  config.berkshelf.berksfile_path = "Berksfile"

  define_singleton_method :box do |name, ip, &block|
    config.vm.define name do |c|
      c.vm.hostname = name.to_s
      c.vm.network :private_network, ip: "10.0.1.#{ip}"

      config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = "."
        chef.data_bags_path = "data_bags"
        chef.roles_path     = "roles"

        chef.add_recipe "chef-solo-search"
        chef.add_recipe "jdabbs::default"

        block.call c, chef unless block.nil?
      end
    end
  end

  # ----------

  box :base, 10

  box :server, 11 do |vm, chef|
    chef.add_role "server"
    chef.json = {
      "mirror" => {
        "create_dirs" => true
      },
      "bitbucket" => {
        "key_label" => "james@server.vm"
      }
    }
  end

  box :dev, 12 do |vm, chef|
    chef.add_role "dev"
    chef.json = {
      "bitbucket" => {
         "key_label" => "james@dev.vm"
      }
    }
  end

end

