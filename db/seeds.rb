30.times do |i|
  name = Faker::Name.name
  email = "example-#{i+1}@gmail.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true, activated_at: Time.zone.now)
end
