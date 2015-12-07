module NanoTwitter
  module Rest
    module V1
      module UsersGet

        def self.registered(app)

          app.get '/api/v1/users' do
            parameter_error unless params['id']
            id = params['id']
            User.find_by_id(id).to_json
          end

          app.get '/api/v1/users/:user_id/tweets' do |user_id|
            num = params['num'] || 10
            num = [num.to_i, 50].min
            user = User.find_by_id(user_id)
            user.tweets.order(tweeted_at: :desc).take(num).to_json
          end

          app.get '/api/v1/users/:user_id/followers' do |user_id|
            user = User.find_by_id(user_id)
            user.followers.to_json
          end

        end
      end
    end
  end
end


