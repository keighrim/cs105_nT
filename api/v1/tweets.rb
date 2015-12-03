require 'uri'

module NanoTwitter
  module Rest
    module V1
      module Tweets

        def self.registered(app)

          insufficient_params = 'Insufficient parameters'
          
          app.get '/api/v1/tweets' do
            unless params['id']
              halt 400, insufficient_params.to_json
            end
            id = params['id']
            Tweet.find_by_id(id).to_json
          end

          app.post '/api/v1/tweets' do
          puts "hi"
            unless params['id']
              halt 400, insufficient_params.to_json
            end
            user = User.find_by_id(params['id'])
            text = URI::decode(params['text']) || '_'
            puts text
            # text
            Tweet.make_tweet(user, text, Time.now).to_json

          end

          app.get '/api/v1/tweets/recent' do
            num = params['num'] || 10
            num = num.to_i
            if num > 50
              num = 50
            end
            Tweet.all.order(tweeted_at: :desc).take(num).to_json
          end
        end
      end
    end
  end
end


