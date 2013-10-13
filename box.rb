class Box
  def initialize hostname, opts={}
    # Set defaults
    ip   = opts[:ip]   || "33.33.33.10"
    json = opts[:json] || {}

    # Build the run list
    @run_list = opts[:run_list] || []
    add_recipe "chef-solo-search"
    [*opts[:recipes]].compact.each { |r| add_recipe r }

    raise "NotImplemented: roles" if opts[:roles]

    # Up!
    Vagrant.configure("2") do |config|
      config.vm.box     = "ubuntu-server-10044-x64-vbox4210-nocm.box"
      config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210-nocm.box"

      # See also :public_network and forwarded port mapping options
      config.vm.network :private_network, ip: ip

      config.omnibus.chef_version     = :latest
      config.berkshelf.enabled        = true
      config.berkshelf.berksfile_path = rel "Berksfile"

      config.vm.hostname = hostname
      config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = rel "."
        chef.data_bags_path = rel "data_bags"

        chef.json     = json
        chef.run_list = @run_list
      end
    end

  end

  private

  def add_recipe r
    r += "::default" unless r =~ /::/
    @run_list << "recipe[#{r}]"
  end

  def rel path
    File.expand_path "../#{path}", __FILE__
  end
end

