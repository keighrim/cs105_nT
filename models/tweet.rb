class Tweet < ActiveRecord::Base
	belongs_to :user
	has_many :timelines
	has_many :users, :through => :timeline
end