module NanoTwitter
  module Test
    module Follow

      def self.registered(app)

        app.get '/test/follow/:num' do |num|
          testuser = User.find_by(name: 'testuser')
          if testuser.nil?
            # TODO need a error page
            'No test user registered. Going back to main in 5 secs.'
            sleep(5)
            redirect '/'
          end
          all_users = (1..User.count).to_a    # DB index starts from 1, not 0
          all_users.delete(testuser.id)
          num.to_i.times do |i|
            following = true
            until !following
              if all_users.size == 0
                'No more user to follow.'
                redirect '/'
              end
              follower_id = all_users.delete_at(rand(all_users.count))
              follower = User.find_by_id(follower_id)
              following = testuser.followed_users.include?(follower)
            end
            testuser.followed_users << follower
          end
          redirect '/'
        end

      end
    end
  end
end


