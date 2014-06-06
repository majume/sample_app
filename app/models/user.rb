class User < ActiveRecord::Base
	before_save { self.email = email.downcase} 	# Here the block is directly passed

	before_create :create_remember_token
		# ':create_remem...' is a 'method reference', Rails looks for this method
		# Will execute it before the controller 'create' method. I.e., before
		# the user is saved into the database
		# As method only used internally can make it private below


	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
					  uniqueness: {case_sensitive: false}

	has_secure_password	
	validates :password, length: {minimum: 6}

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	private
		def create_remember_token
			 self.remember_token = User.encrypt(User.new_remember_token)		  	
		end			  
end
