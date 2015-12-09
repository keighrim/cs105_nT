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

    def get_timeline_view(user)
      cached = $redis.get("partial:#{user.name}")
      if !cached.nil?
        cached
      else
        get_timeline(user)
        timeline_html = partial( :timeline )
        $redis.setex("partial:#{user.name}",3,timeline_html)
        timeline_html
      end
    end

    def get_global_timeline
      if $redis.exists("timeline:recent:50")
        @tweets = $redis.lrange("timeline:recent:50", 0, -1).map { |t| Tweet.new(JSON.parse(t)) }
      else
        @tweets = Tweet.all.order(tweeted_at: :desc).take(50)
        @timeline = @tweets.map { |t| t.to_json }
        if !@timeline.empty?
          $redis.rpush("timeline:recent:50", @timeline)
        end
      end
    end

    def get_global_timeline_view
      cached = $redis.get("partial:top50")
      if !cached.nil?
        cached
      else
        get_global_timeline
        timeline_html = partial( :timeline )
        $redis.setex("partial:top50",3,timeline_html)
        timeline_html
      end
    end

    def is_following?
      !logged_in_user.nil? && logged_in_user.followed_users.include?(@user)
    end

    def tweet(user, text)
      Tweet.make_tweet(user, text, Time.now)
    end

  end
end
