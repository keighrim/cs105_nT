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

  tweet_info = {:user_id=>user.id, :content=>params[:content]}
  @tweet = Tweet.new(tweet_info)

  if @tweet.save
    redirect back
  else
    'Sorry, there was an error!'
  end
end

get '/profile' do
  if params[:name] && param[:name] != session[:logged_in_user_name]
    redirect "/users/#{params[:name]}"
  end

  u_id = session[:logged_in_user_id]
  @user = User.find(u_id)
  if u_id.nil?
    redirect '/register'
    #add a view? Or redirect to the log-in page?
  else
    @tweets = Tweet.where(user_id: u_id)
    erb :profile
  end
end

get '/timeline' do
  if session[:logged_in_user_name].nil?
    @tweets = Tweet.all.order(:tweeted_date).take(50)
  else
    @tweets = User.find(session[:logged_in_user_id]).feeds.order(:tweeted_date)
  end
  erb :timeline
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
	if logged_in_user.nil?
    redirect '/register'
  elsif user_id == logged_in_user_id
		redirect '/profile'
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
      @tweets = Tweet.where(user_id: user_id)
			erb :profile
		end
	end
end


def set_user(name)
  if name
     User.find_by_name(name)
  end
end

def logged_in_user
  User.find_by_id(session[:logged_in_user_id])
end

