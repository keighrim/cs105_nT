class Follow < ActiveRecord::Base
	belongs_to :user
	belongs_to :followed_user, :class_name => "User"

    after_create :add_followed_tweets
    before_destroy :remove_followed_tweets

    private

    def add_followed_tweets
        tweets = self.followed_user.tweets
        tweets.each do |tweet|
            Timeline.create(user_id: self.user_id, tweet_id: tweet.id)
        end
    end

    def remove_followed_tweets
        tweet_ids = self.followed_user.tweets.pluck(:id)
        Timeline.where(user_id: self.user_id, tweet_id: tweet_ids).destroy_all
    end
    
    def self.follow(follower, followed)
        if followed.nil?
            halt 400, 'Sorry, no such user'
        elsif follower.id == followed.id
            halt 400, 'Cannot follow yourself'
        else
            follower.followed_users << followed
        end
    end

    def self.unfollow(unfollower, unfollowed)
        if unfollowed.nil?
            halt 400, 'Sorry, no such user'
        else
            unfollower.followed_users.destroy(unfollowed)
        end
    end
end