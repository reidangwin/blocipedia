# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

5.times do
  u = User.new(
      email: Faker::Internet.safe_email,
      password: Faker::Internet.password,
      role: User.roles.to_a.sample[0]
  )
  u.skip_confirmation!
  u.save
end

users = User.all

50.times do
  long_string = ''
  10.times do
    long_string += ( Faker::MostInterestingManInTheWorld.quote + '. ')
  end

  wiki = Wiki.new(
      user: users.sample,
      title: Faker::Book.title,
      body: long_string,
      private: [true, false].sample
  )
  wiki.save
end

wikis = Wiki.all


# Create an admin user

u = User.new(
    email: 'rangwin+admin@gmail.com',
    password: 'password',
    role: :admin
)
u.skip_confirmation!
u.save

# Create a premium user

u = User.new(
    email: 'rangwin+premium@gmail.com',
    password: 'password',
    role: :premium
)
u.skip_confirmation!
u.save

# Create a standard user

u = User.new(
    email: 'rangwin+standard@gmail.com',
    password: 'password',
    role: :standard
)
u.skip_confirmation!
u.save

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
