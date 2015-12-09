class Tweet < ActiveRecord::Base
  belongs_to :user

  after_create :add_to_timelines
  validates :user, presence: true
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  private

  def add_to_timelines
    #Add to users and followers timelines in redis
    # @users_to_insert = user.followers.to_a
    to_add = self.to_json
    $redis.lpushx("timeline:user:#{user.id}",to_add)
    $redis.ltrim("timeline:user:#{user.id}", 0, 49)
    # @users_to_insert.each do |u|
    #   if $redis.exists("timeline:user:#{u.id}")
    #     $redis.lpushx("timeline:user:#{u.id}", to_add)
    #     $redis.ltrim("timeline:user:#{u.id}", 0, 49)
    #   end
    # end
  
    #Add to the 50 recent tweets timeline in redis
    $redis.lpushx("timeline:recent:50", to_add)
    $redis.ltrim("timeline:recent:50", 0, 49)
  end
  
  def self.make_tweet(user, content, tweeted_at)
    if user.nil?
      'Sorry, no such user'
    end
  
    tweet = Tweet.new(:user_id=>user.id, :user_name=>user.name, :content=>content, :tweeted_at=>tweeted_at)

    if tweet.save
      tweet
    else
      'Sorry, there was an error!'
    end
  end

end