
# This is the dsl (domain specific language) for FactoryGirl
FactoryGirl.define do
	# Passing :user symbol to factory command tells Factory Girl that subsequent
		# definition is for a User model object
	factory :user do
		name "Marc Mentis"
		email "mmentis@optonline.net"
		password "foobar"
		password_confirmation "foobar"
	end
end

