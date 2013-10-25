name             'jdabbs'
maintainer       'James Dabbs'
maintainer_email 'jamesdabbs@gmail.com'
license          'WTFPL (wtfpl.net)'
description      'Installs/Configures jdabbs'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{
  users
  oh-my-zsh
  tmux
  vim
  vim_config
  rbenv
  ruby_build
  samba
  openssh
}.each { |nc| depends nc }

