module NanoTwitter
  module Routes
    module Activities

      def self.registered(app)

        app.post '/tweet' do
          user = logged_in_user
          tweet(user, params[:content], Time.now)
          redirect back
        end

        app.post '/follows' do
          logged_in_user.follow(User.find_by_id(params[:user_id]))
          redirect back
        end

        app.post '/unfollows' do
          logged_in_user.unfollow(User.find_by_id(params[:user_id]))
          redirect back
        end

      end
    end
  end
end


