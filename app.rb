require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' # database configuratio
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
enable :sessions

after {ActiveRecord::Base.connection.close}

get '/' do
	if session[:logged_in_user_id].nil?
		@users = User.all
		erb :index
	else
		@user = logged_in_user
		@is_current_user = true
		erb :profile
	end
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
  redirect '/'
end

get '/register' do
  erb :register
end

post '/register' do
  new_user = User.new(params)
  if new_user.save
    redirect '/'
  else
    'Sorry, there was an error!'
  end
end

get '/register' do
  erb :register
end

post '/tweet' do
  user = logged_in_user
  if user.nil?
    'Sorry, there was an error!'
  end

  tweet_info = {:user_id=>user.id, :content=>params[:content]}
  @tweet = Tweet.new(tweet_info)

  if @tweet.save
    redirect back
  else
    'Sorry, there was an error!'
  end
end

get '/timeline' do
	u_id = session[:logged_in_user_id]
	if u_id.nil?
		redirect '/register'
		#add a view? Or redirect to the log-in page?
	else
		tweet_ids = Timeline.where(user_id: u_id).pluck(:tweet_id)
		@tweets = Tweet.where(id: tweet_ids)
		erb :timeline
	end
end

get '/profile' do
  if params[:name] && param[:name] != session[:logged_in_user_name]
    redirect "/profile/#{params[:name]}"
  end

  u_id = session[:logged_in_user_id]
  if u_id.nil?
    redirect '/register'
    #add a view? Or redirect to the log-in page?
  else
    tweet_ids = Timeline.where(user_id: u_id).pluck(:tweet_id)
    @tweets = []
    tweet_ids.each do |id|
      @tweets << Tweet.find_by_id(id)
    end

    erb :timeline
  end
end

get '/profile/:name' do
  loggin_in = false
  @name = params[:name]
  if @name == session[:logged_in_user_name]
    loggin_in = true
  end
  u_id = User.where(name: @name).first.id

  tweet_ids = Timeline.where(user_id: u_id).pluck(:tweet_id)
  @tweets = []
  tweet_ids.each do |id|
    @tweets << Tweet.find_by_id(id)
  end

  if loggin_in
    erb :timeline
  else
    erb :timeline_only
  end
end

post '/follows' do
	user = User.find_by_id(params[:user_id])
	if user.nil?
		"Sorry, there was an error"
	else
		logged_in_user.followed_users << user
		redirect back
	end
end

post '/unfollows' do
	user = User.find_by_id(params[:user_id])
	logged_in_user_id = session[:logged_in_user_id]
	if user.nil?
		"Sorry, there was an error"
	else
		logged_in_user.followed_users.destroy(user)
		redirect back
	end	
end

get '/users/:user_id' do |user_id|
	logged_in_user_id = session[:logged_in_user_id]
	if user_id == logged_in_user_id
		redirect '/'
	else
		@user = User.find_by_id(user_id)
		if @user.nil?
			"User does not exist"
		else
			@is_current_user = false
			is_following = logged_in_user.followed_users.include?(@user)
			if is_following
				@following = true
			else
				@following = false
			end
			erb :profile
		end
	end
end

def set_user(name)
  if name
    return User.find_by_name(name)
  end
  nil
end

def logged_in_user
  u_id = session[:logged_in_user_id]
  if u_id.nil?
    nil
  else
    User.find_by_id(u_id)
  end
end

