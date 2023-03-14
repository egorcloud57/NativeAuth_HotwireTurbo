# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

u = User.create({ email: 'egorcloud@yandex.ru', name: "Egor", password: '123456',
                password_confirmation: '123456', admin: true, activated: true })
3.times { Note.create({ title: Faker::Name.name, description: Faker::Markdown.emphasis, user_id: u.id }) }

