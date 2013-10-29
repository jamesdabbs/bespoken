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

        chef.add_recipe "chef-solo-search"
        chef.add_recipe "jdabbs::default"

        block.call c, chef unless block.nil?
      end
    end
  end

  # ----------

  box :base, 10

  box :server, 11 do |vm, chef|
    chef.add_recipe "jdabbs::server"
    chef.json = {
      "server" => {
        "vm" => true
      }
    }
  end

  box :medlink, 12 do |vm, chef|
    chef.json = {
      projects: {
        medlink: {
          user:       "james",
          repository: "git://github.com/atlrug-rhok/medlink.git"
        }
      }
    }
  end

  box :yesod_dev, 13 do |vm, chef|
    chef.add_recipe "jdabbs::yesod"
  end
end

