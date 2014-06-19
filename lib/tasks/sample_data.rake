namespace :db  do
	desc "Fill database with sample data"
	task populate: :environment do
		User.create!(name: "Marc Mentis",
					email: "mmentis@optonline.net",
					password: "gan1dolf2",
					password_confirmation: "gan1dolf2",
					admin: true)  # First user is admin, all rest are false. 
										# Default value in db migration set to 'false'

		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@somedomain.org"
			password = "password"

			User.create!(name: name,
						email: email,
						password: password,
						password_confirmation: password)
		end
	end
end