node.set['tmux']['install_method'] = "source"
node.set['tmux']['version']        = "1.8"
node.set['tmux']['checksum']       = "e02a3a0c0dd5aa71dc7b8541f9c5819e3cc29c5b"

include_recipe "tmux::default"

