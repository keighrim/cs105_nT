class Tweet < ActiveRecord::Base
	belongs_to :user
	has_many :timelines
	has_many :users, :through => :timeline

    after_create :add_to_timelines

    private

    def add_to_timelines
        #Adding own tweets to timeline currently, can evaluate this
        Timeline.create(user_id: self.user_id, tweet_id: self.id)
        user.followers.each do |follower|
            Timeline.create(user_id: follower.id, tweet_id: self.id)
        end
    end
end