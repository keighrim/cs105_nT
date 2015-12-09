require 'sinatra'
require 'newrelic_rpm'
require 'logger'
require 'sinatra/activerecord'
require 'sinatra/partial'
require './config/environments' # database configuration
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/routes/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/helpers/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/api/v1/*.rb'].each {|file| require file }

enable :sessions
log = Logger.new(STDOUT)
log.level = Logger::DEBUG

after {ActiveRecord::Base.connection.close}

env_index = ARGV.index("-e")
env_arg = ARGV[env_index + 1] if env_index
env = env_arg || ENV["SINATRA_ENV"] || "development"

# Some global configurations
configure do
  set :version, '1.0'
  set :app_name, 'Nano Twitter'
  set :authors, ['Allan Chesarone', 'Keigh Rim', 'Shu Chen', 'Vladimir Susaya']
  set :partial_template_engine, :erb
  set :public, 'public' # this will provide a directory for static resources
end

if env == 'test'
  User.destroy_all
  Tweet.destroy_all
  u1 = User.create({id:1, name: 'clientUser1', email: 'client1@mail.com', password: 'client'})
  u2 = User.create({id:2, name: 'clientUser2', email: 'client2@mail.com', password: 'client'})
  Tweet.make_tweet(u1, 'client 1 tweeted stuff.', Time.now)
  Tweet.make_tweet(u1, 'client 1 tweeted stuff again.', Time.now)
  Tweet.make_tweet(u2, 'client 2 also tweeted stuff.', Time.now)
  log.debug 'fixture data created in test database...'
end

register NanoTwitter::Routes::Sessions
register NanoTwitter::Routes::Activities
register NanoTwitter::Routes::Views
register NanoTwitter::Routes::ExternalServices

register NanoTwitter::Routes::ResetTestEnv
register NanoTwitter::Routes::StatusTestEnv
register NanoTwitter::Routes::TweetsTest
register NanoTwitter::Routes::SeedTest
register NanoTwitter::Routes::FollowTest

register NanoTwitter::Rest::V1::Tweets
register NanoTwitter::Rest::V1::UsersGet
register NanoTwitter::Rest::V1::UsersUpdate

helpers NanoTwitter::Helpers
helpers NanoTwitter::Helpers::Session
helpers NanoTwitter::Helpers::Errors


