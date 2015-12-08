module NanoTwitter
  module Routes
    module Views

      def self.registered(app)

        app.get '/' do
          redirect "/profile/#{logged_in_user.name}" unless logged_in_user.nil?
          get_global_timeline
          output = partial(:navbar)
          # if $redis.exists("partial:top50")
          #   output << $redis.get("partial:top50")
          # else
          #   tmp = partial( :timeline )
          #   $redis.setex("partial:top50",65,tmp)
          #   output << tmp
          # end
          output << partial( :timeline )
          output
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
          output = partial( :navbar )
          output << partial( :info )
          if params['h'] == '1'
            get_history(@user)
            output << partial( :history )
          else
            get_timeline(@user)
            output << partial( :profile )
            # if $redis.exists("partial:#{user_name}")
            #   output << $redis.get("partial:#{user_name}")
            # else
            #   tmp = partial( :timeline )
            #   $redis.setex("partial:#{user_name}",65,tmp)
            #   output << tmp
            # end
            output << partial( :timeline )
          end
          output
        end

        app.get '/network/:user_name' do |user_name|
          output = partial( :navbar )
          @user = User.find_by(name: user_name)
          user_not_found_error(user_name) if @user.nil?
          output << partial( :info )
          output << partial( :follows )
          output
        end

        app.get '/user/:user_name' do |user_name|
          redirect "/profile/#{user_name}"
        end

        app.get '/explore' do
          @tweets = Tweet.order("RANDOM()").take(50)
          @users = User.order("RANDOM()").take(20)
          output = partial( :navbar )
           # if $redis.exists("partial:top50")
          #   output << $redis.get("partial:top50")
          # else
          #   tmp = partial( :timeline )
          #   $redis.setex("partial:top50",65,tmp)
          #   output << tmp
          # end
          output << partial( :timeline )
          output << partial( :suggested )
          output
        end

      end
    end
  end
end


