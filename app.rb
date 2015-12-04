require 'sinatra'
require 'newrelic_rpm'
require 'logger'
require 'sinatra/activerecord'
require './config/environments' # database configuration
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/test/test*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/helpers/*.rb'].each {|file| require file }

Dir[File.dirname(__FILE__) + '/api/v1/*.rb'].each {|file| require file }
enable :sessions

log = Logger.new(STDOUT)
log.level = Logger::DEBUG

after {ActiveRecord::Base.connection.close}

register NanoTwitter::Test::Reset
register NanoTwitter::Test::Tweets
register NanoTwitter::Test::Seed
register NanoTwitter::Test::FollowTest
register NanoTwitter::Test::Status

helpers NanoTwitter::Helpers::Errors
helpers NanoTwitter::Helpers

register NanoTwitter::Rest::V1::Tweets
register NanoTwitter::Rest::V1::Users

env_index = ARGV.index("-e")
env_arg = ARGV[env_index + 1] if env_index
env = env_arg || ENV["SINATRA_ENV"] || "development"

# Some global configurations
configure do
  set :version, '0.5'
  set :app_name, 'Nano Twitter'
  set :authors, ['Allan Chesarone', 'Keigh Rim', 'Shu Chen', 'Vladimir Susaya']
end

if env == 'test'
  create_test_env
end


# For loader.io verification
get '/loaderio-82d98309070f9f1c9315ff5dcd667982/' do
  'loaderio-82d98309070f9f1c9315ff5dcd667982'
end

#To reset/flush redis cloud database
get '/redis/reset' do
  $redis.flushall
  "All Redis Caches Cleared"
end

get '/' do
  redirect '/timeline'
end

post '/login' do
  username = params[:name]
  password = params[:password]
  u = User.find_by(name: username, password: password)
  unauthorized_error if u.nil?
  session[:logged_in_user_id] = u.id
  session[:logged_in_user_name] = u.name
  redirect '/'
end

get '/logout' do
  session[:logged_in_user_id] = nil
  session[:logged_in_user_name] = nil
  redirect '/'
end

get '/register' do
  erb :register
end

post '/register' do
  new_user = User.new(params)
  if new_user.save
    session[:logged_in_user_id] = new_user.id
    session[:logged_in_user_name] = new_user.name
    redirect '/'
  else
    internal_error
    # halt 500, 'Sorry, there was an error!'
  end
end

post '/tweet' do
  user = logged_in_user
  @tweet = Tweet.make_tweet(user, params[:content], Time.now)
  redirect back
end

get '/profile' do
  @user = logged_in_user
  redirect '/register' if @user.nil?
  @tweets = @user.tweets.order(tweeted_at: :desc)
  erb :profile
end

get '/timeline' do
  if session[:logged_in_user_name].nil?
    if $redis.exists("timeline:recent:50")
      @tweets = $redis.lrange("timeline:recent:50", 0, -1).map{|t| Tweet.new(JSON.parse(t))}
    else
      @tweets = Tweet.all.order(tweeted_at: :desc).take(50)
      @timeline = @tweets.map{|t| t.to_json}
      $redis.rpush("timeline:recent:50", @timeline) if !@timeline.empty?
    end
  else
    @tweets = logged_in_user.timeline
  end

  erb :timeline
end

post '/follows' do
  logged_in_user.follow(User.find_by_id(params[:user_id]))
  redirect back
end

post '/unfollows' do
  logged_in_user.unfollow(User.find_by_id(params[:user_id]))
  redirect back
end

get '/profile/:user_name' do |user_name|
  redirect '/profile' if user_name ==  session[:logged_in_user_name]
  @user = User.where(name: user_name).first
  user_not_found_error(user_name) if @user.nil?
  @is_current_user = false
  if !logged_in_user.nil?
    is_following = logged_in_user.followed_users.include?(@user)
  end
  is_following ? @following = true : @following = false
  @tweets = @user.tweets.order(tweeted_at: :desc)
  erb :profile
end

post '/user/testuser/tweet/:num' do |num|
  redirect "test/tweets/#{num}"
end

get '/user/:user_name' do |user_name|
  redirect "profile/#{user_name}"
end

get '/explore' do
  @tweets = Tweet.order("RANDOM()").take(50)
  @users = User.order("RANDOM()").take(20)
  erb :explore
end

