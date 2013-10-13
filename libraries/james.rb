require 'ostruct'

class Chef::Recipe
  def user name
    _db = data_bag_item "users", name

    id   = _db["id"]
    home = _db["home"] || "/home/#{name}"

    OpenStruct.new({
      id:   id,
      name: name,
      home: home
    })
  end
end


