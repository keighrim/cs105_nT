module NanoTwitter
  module Routes
    module FollowTest

      def self.registered(app)

        app.get '/test/follow/:num' do |num|
          testuser = User.find_by(name: 'testuser')
          bad_request_error 'No test user registered. Going back to main in 5 secs.' if testuser.nil?
          all_users = User.all.pluck(:id)
          all_users.delete(testuser.id)
          num.to_i.times do |i|
            if all_users.size == 0
              bad_request_error 'All users are following testuser'
            end
            follower_id = all_users.delete_at(rand(all_users.count))
            follower = User.find_by_id(follower_id)
            follower.followed_users << testuser
          end
          success "Created #{num} Follows for testuser"
        end

      end
    end
  end
end


