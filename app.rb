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
    @user = get_user_in
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

post '/tweet' do
  user = get_user_in
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
    redirect "/profile/#{params[:name]}"
  end

  u_id = session[:logged_in_user_id]
  if u_id.nil?
    redirect '/register'
    #add a view? Or redirect to the log-in page?
  else
    @tweets = Tweet.find_by_user_id(u_id)
    erb :timeline
  end
end

get '/profile/:name' do
  if @name == session[:logged_in_user_name]
    redirect '/profile'
  end

  u_id = User.find_by_name(@name)
  @tweets = Tweet.find_by_user_id(u_id)
  erb :timeline
end

get '/timeline' do
  if session[:logged_in_user_name].nil?
    @tweets = Tweet.all.take(50)
  end

  @tweets = User.find(session[:logged_in_user_id).tweets
  erb :timeline
end

post '/follows' do
  u1 = set_user(params[:u1])
  u2 = set_user(params[:u2])
  if u1 && u2
    'Sorry, there was an error!'
  else
    u2.followed_users << u1
    u1.followed_users << u2
    redirect back
  end
end

def set_user(name)
  if name
    return User.find_by_name(name)
  end
end

def get_user_in
  User.find_by_id(session[:logged_in_user_id])
end

