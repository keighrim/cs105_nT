require 'typhoeus'
require 'json'
require 'uri'

def parse_response(response)
  if response.code == 200
    JSON.parse(response.body)
  elsif response.code == 404
    nil
  else
    raise response.body
  end
end

def get(url)
  Typhoeus::Request.get(url)
end

def post(url)
  Typhoeus::Request.post(url)
end

def put(url)
  Typhoeus::Request.put(url)
end


class User
  class << self; attr_accessor :base_uri end

  def self.find_by_id(id)
    parse_response(get("#{base_uri}/api/v1/users?id=#{id}"))
  end

  def self.create_user(name, email,password)
    parse_response(post("#{base_uri}/api/v1/users?name=#{name}&email=#{email}&password=#{password}"))
  end

  def self.update_user(id, name, email)
    parse_response(put("#{base_uri}/api/v1/users?id=#{id}&name=#{name}&email=#{email}"))
  end

  def self.update_user_name(id, newname)
    parse_response(put("#{base_uri}/api/v1/users?id=#{id}&name=#{newname}"))

  end

  def self.update_user_email(id, email)
    parse_response(put("#{base_uri}/api/v1/users?id=#{id}&email=#{email}"))
  end

  def self.get_tweets_by_user(id)
    parse_response(get("#{base_uri}/api/v1/users/#{id}/tweets"))
  end

  def self.get_tweets_by_user_and_num(id, num)
    parse_response(get("#{base_uri}/api/v1/users/#{id}/tweets?num=#{num}"))
  end
end


class Tweet
  class << self; attr_accessor :base_uri end

  def self.get_tweets_by_id(id)
    parse_response(get("#{base_uri}/api/v1/tweets?id=#{id}"))
  end

  def self.create_tweet(id, text)
    parse_response(post("#{base_uri}/api/v1/tweets?id=#{id}&text=#{URI::encode(text)}"))
  end

  def self.get_recent_tweets()
    parse_response(get("#{base_uri}/api/v1/tweets/recent"))
  end

  def self.get_num_recent_tweets(num)
    parse_response(get("#{base_uri}/api/v1/tweets/recent?num=#{num}"))
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


