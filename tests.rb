require 'faker'

module Tests

  def self.registered(app)

    app.get '/test/reset' do
      session[:logged_in_user_id] = nil
      session[:logged_in_user_name] = nil
      User.where(name: 'testuser').destroy_all
      User.new(name: 'testuser', email: 'test@u.ser', password: 'test').save
      redirect '/'
    end

    app.get '/test/seed/:num' do |num|
      num.to_i.times do |i|
        saved = false
        until saved
          name = Faker::Internet.user_name
          email = Faker::Internet.email(name)
          u = User.new(name: name, email: email, password: 'deis')
          saved = u.save
        end
      end
      redirect '/'
    end

    app.get '/test/tweets/:num' do |num|
      user = User.where(name: 'testuser').first
      num.to_i.times do |i|
        Tweet.create(user_id: user.id,
                     content: Faker::Hacker.say_something_smart,
                     tweeted_at: Faker::Time.backward(30, :all))
      end
      redirect '/'
    end

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

