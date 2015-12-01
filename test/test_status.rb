module NanoTwitter
  module Test
    module Status

      def self.registered(app)

        app.get '/test/status' do
          num_users = User.count
          num_follows = Follow.count
          num_tweets = Tweet.count
          test_user = User.find_by(name: 'testuser')
          testuser_exists = !test_user.nil?

          result = "Users: #{num_users}<br>Follows: #{num_follows}<br>Tweets: #{num_tweets}<br>\"testuser\" Exists: #{testuser_exists}" 
          if(testuser_exists)
            result = result + "<br>\"testuser\" ID: #{test_user.id}"
          end
        end

      end
    end
  end
end