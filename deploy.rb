#!/usr/bin/env ruby


require 'colorize'

ip       = ARGV.shift || raise("Please specify an address to deploy to")
run_list = ARGV.shift || raise("Please specify a run list")
user     = ARGV.shift || "james".tap { |d| puts "No user specified; using `#{d}`." }

def x cmd
  puts "== $ ".blue + cmd.light_blue + " ==>".blue
  unless system cmd
    puts "xxx ".red + "Returned non-zero".light_red + " xxx".red
    exit
  end
  puts
end

# Make sure all the cookbooks are up to date
# \knife should use the local knife and fix the weird "missing constant" errors
x "\\knife cookbook delete jdabbs"
x "berks install"
x "berks upload"

# Update all the data bags and roles
Dir['data_bags/*/*.json'].each do |db|
  db =~ /data_bags\/(\w+)\/(\w+.json)/
  x "\\knife data bag from file #{$1} #{$2}"
end
Dir['roles/*.rb'].each do |r|
  r =~ /roles\/(\w+.rb)/
  x "\\knife role from file #{$1}"
end

# Start bootstrapping
# SSH should already be configured. Look to --ssh-user if needed.
x "\\knife bootstrap #{ip} --ssh-user '#{user}' --run-list '#{run_list}' --sudo"

