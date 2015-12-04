require_relative './client.rb'

describe "client" do

	before(:each) do
		User.base_uri = "http://localhost:4567" 
		Tweet.base_uri = "http://localhost:4567"
	end

	it "should get a user" do
		user = User.find_by_id(1) 
		expect(user['name']).to eq("clientUser1")
		expect(user['email']).to eq("client1@mail.com")
	end

	it "should return nil for a user not found" do
		puts "Can't test this since API does not account for non existing user"
		# User.find_by_id(3).to eq() "User not found"
	end

	it "should create a user" do
		random_name = ('a'..'z').to_a.shuffle[0,8].join
		random_email = ('a'..'z').to_a.shuffle[0,4].join+"@mail.com"
		user = User.create_user(random_name,random_email,'whatever')
		expect(user['name']).to eq(random_name)
		expect(user['email']).to eq(random_email)
		id = user['id']
		expect(User.find_by_id(id)).to eq(user)
	end

	it "should update a user's username" do
		user = User.update_user_name(1, "clientUser1_new")
		expect(user['name']).to eq("clientUser1_new")
		expect(user['email']).to eq("client1@mail.com")
		expect(User.find_by_id(1)['name']).to eq("clientUser1_new")
		expect(User.find_by_id(1)['email']).to eq("client1@mail.com")
	end

	it "should update a user's email" do
		user = User.update_user_email(1, "client1_new@mail.com")
		expect(user['name']).to eq("clientUser1_new")
		expect(user['email']).to eq("client1_new@mail.com")
		expect(User.find_by_id(1)['name']).to eq("clientUser1_new")
		expect(User.find_by_id(1)['email']).to eq("client1_new@mail.com")
	end

	it "should update a user's profile" do
		user = User.update_user(1, "clientUser1","client1@mail.com")
		expect(user['name']).to eq("clientUser1")
		expect(user['email']).to eq("client1@mail.com")
		expect(User.find_by_id(1)['name']).to eq("clientUser1")
		expect(User.find_by_id(1)['email']).to eq("client1@mail.com")
	end

	it "should get tweets by a user" do
		tweets = User.get_tweets_by_user(1)
		expect(tweets.length).to eq(2)
		expect(tweets[0]['user_name']).to eq("clientUser1")
		expect(tweets[1]['user_name']).to eq("clientUser1")
	end

	it "should get the right number of tweet(s)" do
		tweets = User.get_tweets_by_user_and_num(1,1)
		expect(tweets.length).to eq(1)
		expect(tweets[0]['user_name']).to eq("clientUser1")
	end

	it "should get tweets by id" do
		puts "Unable to test this."
	end

	it "should post a tweet" do
		tweet = Tweet.create_tweet(1,"I tweeted.")
		expect(tweet['user_name']).to eq("clientUser1")
		result = Tweet.get_recent_tweets[0]
		expect(result['user_name']).to eq("clientUser1")
		expect(result['content']).to eq("I tweeted.")
	end

	it "should get recent tweets" do
		tweets = Tweet.get_recent_tweets()
		expect(tweets.length).to be > 0
	end

	it "should get a number of recent tweets" do
		tweets = Tweet.get_num_recent_tweets(2)
		expect(tweets.length).to eq(2)
	end
end