site :opscode

metadata

# users::sysadmins requires search so ...
cookbook 'chef-solo-search'

# Hard lock cookbooks not to require Chef 11 features
cookbook 'apt', '~> 1.10.0'
cookbook 'mercurial', '~> 1.1.4'

cookbook 'users'
cookbook 'oh-my-zsh'
cookbook 'vim_config', git: 'https://github.com/promisedlandt/cookbook-vim_config.git'
cookbook 'tmux'
cookbook 'rbenv', git: 'https://github.com/fnichol/chef-rbenv.git'
cookbook 'ruby_build'

