module NanoTwitter
  module Rest
    module V1
      module Users


        def self.registered(app)

          insufficient_params = 'Insufficient parameters'

          app.get '/api/v1/users' do
            unless params['id']
              halt 400, insufficient_params.to_json
            end
            id = params['id']
            User.find_by_id(id).to_json
          end

          app.post '/api/v1/users' do
            if !params['name'] || !params['email']
              halt 400, insufficient_params.to_json
            end
            username = params['name']
            email = params['email']
            user = User.new({name: username, email: email, password: 'deis'})
            if user.save
              user.to_json
            else
              # TODO check duplicate
              halt 500
            end
          end

          app.put '/api/v1/users' do
            if !params['id'] 
              halt 400, insufficient_params.to_json
            elsif params['password']
              halt 400, 'Changing password over REST API is not allowed.'.to_json
            end
            user = User.find_by_id(params['id'])
            params.each do |key, value|
              begin
                user[key] = value
              rescue ActiveModel::MissingAttributeError
              end
            end

            if user.save
              user.to_json
            else
              # TODO check duplicate
              halt 500
            end
          end

          app.get '/api/v1/users/:user_id/tweets' do |user_id|
            num = params['num'] || 10
            num = num.to_i
            if num > 50
              num = 50
            end
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


