include_recipe "vim::default"

conf = "/etc/vim"

node.set["vim_config"]["installation_dir"] = conf

node.set["vim_config"]["config_file_mode"]     = "cookbook"
node.set["vim_config"]["config_file_template"] = ".rc/.vimrc"
node.set["vim_config"]["config_file_cookbook"] = "jdabbs"

node.set["vim_config"]["bundles"]["git"] = [
  "https://github.com/mileszs/ack.vim.git",
  "https://github.com/kien/ctrlp.vim.git",
  "https://github.com/scrooloose/nerdcommenter.git",
  "https://github.com/scrooloose/nerdtree.git",
  "https://github.com/myusuf3/numbers.vim.git",
  "https://github.com/tpope/vim-classpath.git",
  "https://github.com/guns/vim-clojure-static.git",
  "https://github.com/tpope/vim-fireplace.git",
  "https://github.com/airblade/vim-gitgutter.git"
]

# vim_config appears to install pathogen to the wrong place
# This installs in manually
directory "#{conf}/autoload"
remote_file "#{conf}/autoload/pathogen.vim" do
  source "https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
end

include_recipe "vim_config::default"

