module NanoTwitter
  module Helpers

    def logged_in_user
      User.find_by_id(session[:logged_in_user_id])
    end

    def success(message)
      status 200
      body message
    end

    def get_history(user)
      @tweets = user.tweets.order(tweeted_at: :desc)
    end

    def get_timeline(user)
      @tweets = user.build_timeline
    end

    def get_timeline_view(username)
      if $redis.ttl("partial:#{username}")>0
        $redis.get("partial:#{username}")
      else
        timeline_html = partial( :timeline )
        $redis.setex("partial:#{username}",2,timeline_html)
        timeline_html
      end
    end

    def get_global_timeline
      if $redis.exists("timeline:recent:50")
        @tweets = $redis.lrange("timeline:recent:50", 0, -1).map { |t| Tweet.new(JSON.parse(t)) }
      else
        @tweets = Tweet.all.order(tweeted_at: :desc).take(50)
        @timeline = @tweets.map { |t| t.to_json }
        $redis.rpush("timeline:recent:50", @timeline) if !@timeline.empty?
      end
    end

    def get_global_timeline_view
      get_timeline_view("top50")
    end

    def is_following?
      !logged_in_user.nil? && logged_in_user.followed_users.include?(@user)
    end

    def tweet(user, text)
      Tweet.make_tweet(user, text, Time.now)
    end

  end
end
