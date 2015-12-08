module NanoTwitter
  module Routes
    module Views

      def self.registered(app)

        app.get '/' do
          redirect "/profile/#{logged_in_user.name}" unless logged_in_user.nil?
          # get_global_timeline
          output = partial(:navbar)
          output << get_global_timeline_view
          output
        end

        app.get '/timeline' do
          redirect '/'
        end

        app.get '/profile' do
          redirect '/'
        end

        app.get '/profile/:user_name' do |user_name|
          @user = User.find_by(name: user_name)
          user_not_found_error(user_name) if @user.nil?
          @following = is_following?
          output = partial( :navbar )
          output << partial( :info )
          if params['m'] == 'h'
            get_history(@user)
            output << partial( :history )
          elsif params['m'] == 'n'
            output << partial( :follows )
          else
            output << partial( :profile )
            # get_timeline(@user)
            output << get_timeline_view(@user)
          end
          output
        end

        app.get '/user/:user_name' do |user_name|
          redirect "/profile/#{user_name}"
        end

        app.get '/explore' do
          @tweets = Tweet.order("RANDOM()").take(50)
          @users = User.order("RANDOM()").take(20)
          output = partial( :navbar )
          output << get_global_timeline_view
          output << partial( :suggested )
          output
        end

      end
   end
  end
end


