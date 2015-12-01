require 'faker'

module NanoTwitter
  module Test
    module Tweets

      def self.registered(app)

        app.get '/test/tweets/:num' do |num|
          user = User.where(name: 'testuser').first
          num.to_i.times do |i|
            Tweet.create(user_id: user.id, user_name: user.name,
                         content: Faker::Hacker.say_something_smart,
                         tweeted_at: Time.now)
          end
          "Created #{num} Tweets"
        end

        app.get '/test/tweet/:user_id' do |user_id|
          user = User.find_by_id(user_id)
          if user.nil?
            "User with id #{user_id} does not exist"
          else
            Tweet.make_tweet(user, Faker::Hacker.say_something_smart, Time.now)
            "User with id #{user_id} has tweeted"
          end
        end
      end
    end
  end
end
