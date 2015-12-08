require './app'
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
use Rack::Deflater
run Sinatra::Application
