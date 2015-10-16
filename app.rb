require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' # database configuratio
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
# enable :sessions

get '/' do
	@users = User.all
	erb :index
end

get '/register' do
	erb :register
end

post '/register' do
	new_user = User.new(params)
	if new_user.save
		redirect '/'
	else
		"Sorry, there was an error!"
	end
end

get '/register' do
	erb :register
end

post '/tweet' do	
	user = set_user(params[:name])
	if user.nil?
		"Sorry, there was an error!"
	end

	tweet_info = {:user_id=>user.id, :content=>params[:content]}
	@tweet = Tweet.new(tweet_info)

	if @tweet.save
		redirect '/timeline'
	else
		"Sorry, there was an error!"
	end
end

get '/timeline' do
	@tweets = Tweet.all.shuffle
	erb :timeline
end

post '/follows' do
	u1 = set_user(params[:u1])
	u2 = set_user(params[:u2])
	unless u1.nil? || u2.nil?
		u2.followed_users << u1
		u1.followed_users << u2
		redirect '/'
	else
		"Sorry, there was an error!"
	end
end

def set_user(name)
	if !name.nil?
		return User.find_by_name(name)
	end

	return nil
end