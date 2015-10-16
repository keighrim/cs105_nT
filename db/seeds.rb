require 'faker'

10.times do |i|
  name = Faker::Internet.user_name
  email = Faker::Internet.email(name)
  
  user = User.create(name: name, email: email)

  rand(0..10).times do |j|
    Tweet.create(user_id: user.id, content: Faker::Hacker.say_something_smart)
  end
end


all_users = User.all

50.times do
  pair = all_users.sample(2)

  unless pair[0].followers.exists?(pair[1].id)
    pair[0].followers << pair[1]
  end
end


