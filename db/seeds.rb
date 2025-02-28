30.times do |i|
  name = Faker::Name.name
  email = "example-#{i+1}@rails-tutorial.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end
