require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(:name => "Example User",
					   :username => "example_user_admin",
                       :email => "example@railstutorial.org",
                       :password => "foobar",
                       :password_confirmation => "foobar")
  admin.toggle!(:admin)
  rand = 10 + rand(30)
  rand.times do |n|
    name  = Faker::Name.name
    fixed_name = name.gsub(" ", "_").downcase
    username = "#{name.gsub(" ", "_").downcase}_#{n}"
    
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(:name => name,
				 :username => username,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_microposts
  User.all(:limit => 10).each do |user|
    10.times do
      content = Faker::Lorem.sentence(5)
      user.microposts.create!(:content => content)
    end
  end
end

def make_relationships
  users = User.all
  user  = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end
