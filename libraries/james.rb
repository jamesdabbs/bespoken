require 'ostruct'

class Chef::Recipe
  def user name
    _db = data_bag_item "users", name
    _db["home"] ||= "/home/#{name}"
    OpenStruct.new _db
  end
end


