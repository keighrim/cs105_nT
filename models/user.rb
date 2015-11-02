class User < ActiveRecord::Base
  has_many :follows, dependent: :destroy
  has_many :followed_users, :through => :follows
  has_many :followings, :class_name => 'Follow', :foreign_key => :followed_user_id
  has_many :followers, :through => :followings, :source => :user

  has_many :timelines
  has_many :tweets, dependent: :destroy
  has_many :feeds, :through => :timelines, :source => :tweet

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true, length: { minimum: 2 }
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i


end