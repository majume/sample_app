# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

#This is the hard wired secret key
#SampleApp::Application.config.secret_key_base = '9df1427b31670fb1d55086a0df56152f472c9f602be737d4653c874d16957a994cf31380409b01a120498b8fa50290d899aa1c76f96ee93386e4c38c63f18eec'

#This is the script to dynamically generate the secret key
#If the application is to be sared as a public repository - security risk
		require 'securerandom'

		def secure_token
			token_file = Rails.root.join('.secret')
			if File.exists?(token_file)
				#Use the existing token
				File.read(token_file).chomp
			else
				#Generate a new token and store it in token_file
				token = SecureRandom.hex(64)
				File.write(token_file, token)
				token
			end
		end
		SampleApp::Application.config.secret_key_base = secure_token 
