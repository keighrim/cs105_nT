module NanoTwitter
  module Helpers

    def logged_in_user
      User.find_by_id(session[:logged_in_user_id])
    end

    def create_test_env
      User.destroy_all
      Tweet.destroy_all
      u1 = User.create({id:1, name: 'clientUser1', email: 'client1@mail.com', password: 'client'})
      u2 = User.create({id:2, name: 'clientUser2', email: 'client2@mail.com', password: 'client'})
      Tweet.make_tweet(u1, 'client 1 tweeted stuff.', Time.now)
      Tweet.make_tweet(u1, 'client 1 tweeted stuff again.', Time.now)
      Tweet.make_tweet(u2, 'client 2 also tweeted stuff.', Time.now)
      log.debug 'fixture data created in test database...'
    end

  end
end
