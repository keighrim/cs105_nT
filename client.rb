require 'typhoeus'
require 'json'
require 'uri'

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

    def self.create_user(name, email,password)
        response = Typhoeus::Request.post(
            "#{base_uri}/api/v1/users?name=#{name}&email=#{email}&password=#{password}")
        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
    end

    def self.update_user_name(id, newname)

        response = Typhoeus::Request.put(
            "#{base_uri}/api/v1/users?id=#{id}&name=#{newname}")

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


class Tweet
    class << self; attr_accessor :base_uri end

    def self.get_tweets_by_id(id)
        response = Typhoeus::Request.get(
            "#{base_uri}/api/v1/tweets?id=#{id}")
        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
    end


    def self.create_tweet(id, text)
        response = Typhoeus::Request.post(
            "#{base_uri}/api/v1/tweets?id=#{id}&text=#{URI::encode(text)}")

        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
    end

    def self.get_recent_tweets()
        response = Typhoeus::Request.get(
            "#{base_uri}/api/v1/tweets/recent")
        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
    end

    def self.get_num_recent_tweets(num)
        response = Typhoeus::Request.get(
            "#{base_uri}/api/v1/tweets/recent?num=#{num}")
        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
    end

end

# #sample usage. still needs proper tests

# User.base_uri = "http://localhost:4567"
# json_output = User.find_by_id(1)
# puts json_output
# json_output = User.find_by_id(2)
# puts json_output

# #needs test because this fails after the first call-- can't have multiple users with the same name
# #json_output = User.create_user("clienttestuser", "clienttest@test.edu")
# #puts json_output

# json_output = User.update_user_name(1, "clienttestname2")
# puts json_output
# json_output = User.update_user_email(2, "clienttest2@test.edu")
# puts json_output
# json_output = User.update_user(1, "clienttestname3", "clienttest3@test.edu")
# puts json_output
# json_output = User.get_tweets_by_user(1)
# puts json_output
# puts json_output[0]["user_name"]
# json_output = User.get_tweets_by_user_and_num(1, 3)
# puts json_output


# Tweet.base_uri = "http://localhost:4567"
# #json_output = Tweet.get_tweets_by_id(2)
# #puts json_output

# json_output = Tweet.create_tweet(1, "this is my tweet. wooo")
# puts json_output

# json_output = Tweet.get_recent_tweets()
# puts json_output
# json_output = Tweet.get_num_recent_tweets(4)
# puts json_output


