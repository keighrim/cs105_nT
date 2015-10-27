require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' # database configuratio
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
enable :sessions

after {ActiveRecord::Base.connection.close}

get '/' do
  redirect '/timeline'
end

post '/login' do
	username = params[:name]
  password = params[:password]
  u = User.find_by(name: username, password: password)
  if u.nil?
    #add a redirect to a invalid login page
    'Invalid login credentials'
  else
    session[:logged_in_user_id] = u.id
    session[:logged_in_user_name] = u.name
    redirect '/'
  end
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
    'Sorry, there was an error!'
  end
end

post '/tweet' do
  user = logged_in_user
  if user.nil?
    'Sorry, there was an error!'
  end

  tweet_info = {:user_id=>user.id, :content=>params[:content], tweeted_at: Time.now}
  @tweet = Tweet.new(tweet_info)

  if @tweet.save
    redirect back
  else
    'Sorry, there was an error!'
  end
end

get '/profile' do
  @user = logged_in_user
  if @user.nil?
    redirect '/register'
  else
    @tweets = @user.tweets.order(tweeted_at: :desc)
    erb :profile
  end
end

get '/timeline' do
  if session[:logged_in_user_name].nil?
    @tweets = Tweet.all.order(tweeted_at: :desc).take(50)
  else
    @tweets = User.find(session[:logged_in_user_id]).feeds.order(tweeted_at: :desc)
  end
  erb :timeline
end

post '/follows' do
  user = User.find_by_id(params[:user_id])
  if user.nil?
    'Sorry, there was an error'
  else
    logged_in_user.followed_users << user
    redirect back
  end
end

post '/unfollows' do
  user = User.find_by_id(params[:user_id])
  logged_in_user_id = session[:logged_in_user_id]
  if user.nil?
    'Sorry, there was an error'
  else
    logged_in_user.followed_users.destroy(user)
    redirect back
  end
end

get '/profile/:user_name' do |user_name|
  if user_name ==  session[:logged_in_user_name]
    redirect '/profile'
  else
    @user = User.where(name: user_name).first
    if @user.nil?
      "Oops, user \"#{user_name}\" does not exist"
    else
      @is_current_user = false
      if !logged_in_user.nil?
        is_following = logged_in_user.followed_users.include?(@user)
      end
      if is_following
        @following = true
      else
        @following = false
      end
      @tweets = @user.tweets
      erb :profile
    end
  end
end

=begin
get '/profile/:user_id' do |user_id|
  logged_in_user_id = session[:logged_in_user_id]
  if logged_in_user.nil?
    redirect '/register'
  elsif user_id == logged_in_user_id
    redirect '/profile'
  else
    @user = User.find_by_id(user_id)
    if @user.nil?
      'User does not exist'
    else
      @is_current_user = false
      is_following = logged_in_user.followed_users.include?(@user)
      if is_following
        @following = true
      else
        @following = false
      end
      @tweets = @user.tweets
      erb :profile
    end
  end
end
=end

def logged_in_user
  User.find_by_id(session[:logged_in_user_id])
end

