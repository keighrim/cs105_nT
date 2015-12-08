require 'uri'

module NanoTwitter
  module Rest
    module V1
      module Tweets

        def self.registered(app)

          app.get '/api/v1/tweets' do
            parameter_error unless params['id']
            id = params['id']
            Tweet.find_by_id(id).to_json
          end

          app.post '/api/v1/tweets' do
            parameter_error unless params['id']
            user = User.find_by_id(params['id'])
            text = URI::decode(params['text']) || '_'
            tweet(user, text).to_json
          end

          app.get '/api/v1/tweets/recent' do
            num = params['num'] || 10
            num = [num.to_i, 50].min
            Tweet.all.order(tweeted_at: :desc).take(num).to_json
          end
        end
      end
    end
  end
end


