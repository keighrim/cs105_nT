class Follow < ActiveRecord::Base
	belongs_to :user
	belongs_to :followed_user, :class_name => "User"

    after_create :add_followed_tweets
    before_destroy :remove_followed_tweets

    private

    def add_followed_tweets
        tweets = User.find_by_id(self.followed_user_id).tweets
        tweets.each do |tweet|
            Timeline.create(user_id: self.user_id, tweet_id: tweet.id)
        end
    end

    def remove_followed_tweets
        tweet_ids = User.find_by_id(self.followed_user_id).tweets.pluck(:id)
        Timeline.where(user_id: self.user_id, tweet_id: tweet_ids).destroy_all
    end
end