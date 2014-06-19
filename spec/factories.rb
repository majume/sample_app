
# This is the dsl (domain specific language) for FactoryGirl
# FactoryGirl.define do
# 	# Passing :user symbol to factory command tells Factory Girl that subsequent
# 		# definition is for a User model object
# 	factory :user do
# 		name "Marc Mentis"
# 		email "mmentis@optonline.net"
# 		password "foobar"
# 		password_confirmation "foobar"
# 	end
# end


# This is the dsl (domain specific language) for FactoryGirl
FactoryGirl.define do
	# Passing :user symbol to factory command tells Factory Girl that subsequent
		# definition is for a User model object
	factory :user do
		sequence(:name) { |n| "Person #{n}"}
		sequence(:email) { |n| "person_#{n}@optonline.net" }
		  # sequence method takes a symbol corresponding to the desired attribute
		  	# i.e., :name, and a block with one variable - called 'n' here. 
		  	# Upon successive invocations of the FactoryGirl method 'FactoryGirl.create(:user)'
		  	# the block variable is automatically incremented, so that the first user has name
		  	# "Person 1" and email address "person_1@ooptonline.net."
		password "foobar"
		password_confirmation "foobar"
	end
end


