class CreateTweet < ActiveRecord::Migration
  def change
  	create_table :tweets do |t|
  		t.integer :user_id
  		t.string :content
  		t.date :tweeted_date
  	end
  end
end




# table tweets
# 	id: integer primary_key
# 	user_id: integer foreign_key
# 	content: string
# 	tweeted_date: date
	
# 	tweets belongs_to users
