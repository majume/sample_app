require 'spec_helper'

describe User do
	before {@user = User.new(name: "Example User", email: "user@example.com",
							password: "foobar", password_confirmation: "foobar") }

	subject {@user}

	it {should respond_to(:name)}
	it {should respond_to(:email)}
	it {should respond_to(:password_digest)}
	it {should respond_to(:password)}
	it {should respond_to(:password_confirmation)}
	it {should respond_to(:remember_token)}
	it {should respond_to(:authenticate)}

	it {should be_valid}

	describe "when name is not present" do
		before {@user.name = ""}
		it {should_not be_valid}
	end

	describe "when eMail is not present" do
		before {@user.email = ""}
		it {should_not be_valid}
	end

	describe "when name length > 50" do
		before {@user.name = "a" * 51}
		it {should_not be_valid}
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_bas.com
			 foo@bar+bas.com]
			 addresses.each do |invalid_address|
			 	@user.email = invalid_address
			 	expect(@user).not_to be_valid
			 end
		end
	end

	describe "when eMail format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@bas.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				expect(@user).to be_valid
			end
		end
	end

	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it {should_not be_valid}
	end

	describe "when password not present" do
		before do
			@user = User.new(name: "Example User", email: "user@example.com",
							password: "", password_confirmation: "")
		end
		it {should_not be_valid}
	end

	describe "with a password that is too short" do
  		before {@user.password = @user.password_confirmation = "a" * 5}

  		it {should be_invalid}
  	end

	describe "when password doesn't match confirmation" do
		before {@user.password_confirmation = "mismatch"}
		# before do
		# 	@user = User.new(name: "Example User", email: "user@exam.com",
		# 					password: "foobar", password_confirmation: "foo")
		# end
		it {should_not be_valid}
	end
  	
  	describe "return value of authenticate method" do
  		before {@user.save}
  			# Save the @user to the database before running all the 'it', or 'specify'
  		let(:found_user) {User.find_by(email: @user.email)}
  			# Create a variable 'found_user' with value from block
  				# let method is convenient way to create local variable within test
  				# This variable can be used in it or before blocks
  			# 'found_user' is memoized I.e., value percists from one invocation to next

  		describe "with valid password" do
  			it {should eq found_user.authenticate(@user.password)}
  				# user.authenticate(password) will return 'user' if password matches
  					# or 'false' if password does not match
  				# I.e., read: it (found_user) == found_user.authenticate(@user.password)
  		end

  		describe "with invalid password" do
  			let(:user_for_invalid_password) {found_user.authenticate("invalid")}
  				# Set 'user_for_invalid_password' to be false

  			it {should_not eq user_for_invalid_password}
  				# Read: it (found_user) != user_for_invalid_password
  					# Because found_user is memoized database not hit this time
  			specify {expect(user_for_invalid_password).to be_false}
  			# it {expect(user_for_invalid_password).to be_false}
  				# 'specify' == 'it'. Use it when reading in english sounds better
  					# both will work
  				# Read: specify: expect user_for_invalid_password.to be_false
  					# Sounds better than: it expect user_for_invalid_password.to be_false
  		end
  	end


  	describe "remember_token is not blank" do
  		before {@user.save}
  		its(:remember_token) {should_not be_blank}
  	end

  	
end
