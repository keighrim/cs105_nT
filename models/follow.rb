class Follow < ActiveRecord::Base
	belongs_to :user
	belongs_to :followed_user, :class_name => "User"

    after_create :add_followed_tweets
    before_destroy :remove_followed_tweets

    private

    def add_followed_tweets
        tweets = Tweet.where(user_id: self.followed_user_id)
        tweets.each do |tweet|
            Timeline.create(user_id: self.user_id, tweet_id: tweet.id)
        end
    end

    def remove_followed_tweets
        tweets = Tweet.where(user_id: self.followed_user_id)
        tweets.joins(:timelines).where(user_id: self.user_id).destroy_all
    end
end