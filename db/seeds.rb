User.create(name: 'sherief', email: 'test@test.com', password: '12345678')

10.times do
  u = User.create(name: Faker::Name.unique.first_name, email: Faker::Internet.unique.email, password: '11111111')
end
