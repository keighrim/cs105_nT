require 'minitest/autorun'
require 'sinatra/activerecord'
#require_relative '../config/environments'
#require_relative '../models/user'
#require_relative '../models/tweet'
#require_relative '../models/timeline'
#require_relative '../models/follow'

require './models/user'
require './models/tweet'
require './models/timeline'
require './models/follow'

describe User do

  before do
    @test_user = User.create(name: "some_username", email: "fakeemail@email.com", password: "deis")
    @test_user_2 = User.create(name: "followed_username", email: "fakeemail2@email.com", password: "deis")
  end

  after do
    User.delete(@test_user.id)
    User.delete(@test_user_2.id)
  end

  it "has a required parameters" do
    @test_user.name.wont_be_nil && @test_username.email.wont_be_nil
  end

  it "can follow another user" do
    @test_user.follow(@test_user_2)
    @test_user.followed_users.include?(@test_user_2).must_equal true
  end

  it "cannot follow itself" do
    @test_user.follow(@test_user)
    @test_user.followed_users.include?(@test_user).must_equal false
  end

  it "can unfollow another user" do
    @test_user.follow(@test_user_2)
    @test_user.followed_users.include?(@test_user_2).must_equal true
    @test_user.unfollow(@test_user_2)
    @test_user.followed_users.include?(@test_user_2).must_equal false
  end
    
end


describe Tweet do
    
  before do
    @test_user = User.create(name: "some_username", email: "fakeemail@email.com", password: "deis")
  end
    
  after do
    User.delete(@test_user.id)
  end
    
  it "can be made by a user" do
    tweet = Tweet.make_tweet(@test_user, @test_user.id, "content here", Time.now)
    tweet.wont_equal 'Sorry, there was an error!'
    Tweet.destroy(tweet.id)
  end
	
  #content is 150 characters long
  it "has no more than 140 characters" do
    tweet = Tweet.make_tweet(@test_user, @test_user.id, "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789", Time.now)
    tweet.must_equal 'Sorry, there was an error!'
  end
    
end



describe Timeline do

  it "contains an entry for a given tweet, for its creator and their followers" do

  end

    
end

describe Follow do

  it "adds tweets when a unfollowed user is followed" do

  end

  it "removes tweets when a followed user is unfollowed" do

  end
  
  
    
end

