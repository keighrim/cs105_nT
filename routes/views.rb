module NanoTwitter
  module Routes
    module Views

      def self.registered(app)

        app.get '/' do
          redirect "/profile/#{logged_in_user.name}" unless logged_in_user.nil?
          get_global_timeline
          erb :timeline
        end

        app.get '/timeline' do
          redirect '/'
        end

        app.get '/profile' do
          redirect "/profile/#{logged_in_user.name}"
        end

        app.get '/profile/:user_name' do |user_name|
          @user = User.find_by(name: user_name)
          user_not_found_error(user_name) if @user.nil?
          @following = is_following?
          if params['h'] == '1'
            get_history(@user)
            erb :history
          else
            get_timeline(@user)
            erb :profile
          end
        end

        app.get '/user/:user_name' do |user_name|
          redirect "/profile/#{user_name}"
        end

        app.get '/explore' do
          @tweets = Tweet.order("RANDOM()").take(50)
          @users = User.order("RANDOM()").take(20)
          erb :explore
        end

      end
    end
  end
end


