class Follow < ActiveRecord::Base
  belongs_to :user
  belongs_to :followed_user, :class_name => "User"
  validates_uniqueness_of :followed_user_id, :scope => :user_id


  after_create :rebuild_redis
  after_destroy :rebuild_redis

  private

  def rebuild_redis
    $redis.del("timeline:user:#{user.id}")
    # user.timeline
  end

  def self.follow(follower, followed)
    if followed.nil?
      'Sorry, there was an error'
    elsif follower.id == followed.id
      'Cannot follow yourself'
    else
      follower.followed_users << followed
    end
  end

  def self.unfollow(unfollower, unfollowed)
    if unfollowed.nil?
      'Sorry, there was an error'
    else
      unfollower.followed_users.destroy(unfollowed)
    end
  end
end