
module NanoTwitter
  module Test
    module Reset

      def self.registered(app)

        app.get '/test/reset/testuser' do
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

          success "Test Reset for \"testuser\" Successful"
        end

        app.get '/test/reset/all' do
          session[:logged_in_user_id] = nil
          session[:logged_in_user_name] = nil
          Tweet.delete_all
          Follow.delete_all
          User.delete_all
          $redis.flushall
          User.new(name: 'testuser', email: 'test@u.ser', password: 'test').save
          success "Total Reset Complete \n User \"testuser\" Created"
        end

      end
    end
  end
end



