require 'ostruct'

class Chef::Recipe
  def user name
    _db = data_bag_item "users", name
    _db["home"] ||= "/home/#{name}"
    OpenStruct.new _db
  end

  def defaults *args
    conf = args.pop
    n = args.reduce(node.default) { |mem,path| mem[path] }
    conf.each { |k,v| n[k] = v }
  end
end


