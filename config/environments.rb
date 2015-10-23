# These Settings Establish the Proper Database Connection for Heroku Postgres
# The environment variable DATABASE_URL should be in the following format:
#     => postgres://{user}:{password}@{host}:{port}/path
# This is automatically configured on Heroku, you only need to worry if you also
# want to run your app locally
require 'better_errors'

configure :production do
  puts '[production environment]'
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

  ActiveRecord::Base.establish_connection(
      :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
  )
end

configure :development, :test do
  puts '[development or test Environment]'
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end
