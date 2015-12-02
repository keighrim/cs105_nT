require 'typhoeus'
require 'json'

class User
    class << self; attr_accessor :base_uri end

    def self.find_by_id(id)
        response = Typhoeus::Request.get(
            "#{base_uri}/api/v1/users?id=#{id}")
        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
    end
end


User.base_uri = "http://localhost:4567"
json_output = User.find_by_id(1)
puts json_output