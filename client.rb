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

    def self.create_user(name, email)
        response = Typhoeus::Request.post(
            "#{base_uri}/api/v1/users?name=#{name}&email=#{email}")
        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
    end

    def self.update_user_name(id, name)

        response = Typhoeus::Request.put(
            "#{base_uri}/api/v1/users?id=#{id}&name=#{name}")

        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
    end

    def self.update_user_email(id, email)

        response = Typhoeus::Request.put(
            "#{base_uri}/api/v1/users?id=#{id}&email=#{email}")

        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
    end

    def self.update_user(id, name, email)
        response = Typhoeus::Request.put(
            "#{base_uri}/api/v1/users?id=#{id}&name=#{name}&email=#{email}")
        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
    end

    def self.get_tweets_by_user(id)
        response = Typhoeus::Request.put(
            "#{base_uri}/api/v1/users?id=#{id}")
        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
    end

    def self.get_tweets_by_user(id)
        response = Typhoeus::Request.get(
            "#{base_uri}/api/v1/users/#{id}/tweets")
        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
    end

    def self.get_tweets_by_user_and_num(id, num)
        response = Typhoeus::Request.get(
            "#{base_uri}/api/v1/users/#{id}/tweets?num=#{num}")
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
json_output = User.find_by_id(2)
puts json_output

#needs test because this fails after the first call-- can't have multiple users with the same name
#json_output = User.create_user("clienttestuser", "clienttest@test.edu")
#puts json_output

json_output = User.update_user_name(2, "clienttestname2")
puts json_output
json_output = User.update_user_email(2, "clienttest2@test.edu")
puts json_output
json_output = User.update_user(2, "clienttestname3", "clienttest3@test.edu")
puts json_output

json_output = User.get_tweets_by_user(1)
puts json_output
json_output = User.get_tweets_by_user_and_num(1, 3)
puts json_output

