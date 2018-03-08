User.create(name: 'a', email: 'a@a', password: '12345678')
User.create(name: 'ray', email: 'ray@email.com', password: '12345678')
User.create(name: 'sherief', email: 'sherief@email.com', password: '12345678')
User.create(name: 'dan', email: 'dan@email.com', password: '12345678')
User.create(name: 'mike', email: 'mike@email.com', password: '12345678')

# 10.times do
#   u = User.create(name: Faker::Name.unique.first_name, email: Faker::Internet.unique.email, password: '11111111')
# end
