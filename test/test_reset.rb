
module NanoTwitter
  module Test
    module Reset

      def self.registered(app)

        app.get '/test/reset' do
          session[:logged_in_user_id] = nil
          session[:logged_in_user_name] = nil
          @user = User.find_by(name: 'testuser')
          if @user.nil?
            User.new(name: 'testuser', email: 'test@u.ser', password: 'test').save
          else
            Tweet.where(user_id: @user.id).destroy_all
            Follow.where(user_id: @user.id).destroy_all
            Follow.where(followed_user_id: @user.id).destroy_all
            $redis.del("timeline:user:#{@user.id}")
            $redis.del("timeline:recent:50")
          end

          "Test Reset Run Successful"
        end
      end
    end
  end
end



