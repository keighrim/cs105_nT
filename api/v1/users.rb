module NanoTwitter
  module Rest
    module V1
      module Users


        def self.registered(app)

          app.get '/api/v1/users' do
            parameter_error unless params['id']
            id = params['id']
            User.find_by_id(id).to_json
          end

          app.post '/api/v1/users' do
            parameter_error if !params['name'] || !params['email']
            username = params['name']
            email = params['email']
            user = User.new({name: username, email: email, password: 'deis'})
            internal_error unless user.save
            user.to_json if user.save
          end

          app.put '/api/v1/users' do
            parameter_error if !params['id']
            halt 400, not_allowed_error('Changing password over REST API').to_json if params['password']
            user = User.find_by_id(params['id'])
            params.each do |key, value|
              begin
                user[key] = value
              rescue ActiveModel::MissingAttributeError
                #ignoring irrelevant attribs
              end
            end
            internal_error unless user.save
            user.to_json if user.save
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


