require 'spec_helper'
require 'support/utilities'


describe "UserPages" do
	subject {page}

	describe "profile page" do
		# Create user variable - using FactoryGirl
		let(:user) {FactoryGirl.create(:user)}

		before { visit user_path(user) }
		  it { should have_content(user.name) }
		  it { should have_title(user.name) }
	end

	describe "edit" do
		# Create user variable - using FactoryGirl
		let(:user) {FactoryGirl.create(:user)}
		before do 
			sign_in user  # sign_in FUNCTION in spec/support/utilities
			visit edit_user_path(user)
		end

		describe "edit page" do
			it { should have_content("Update your profile")}
			it { should have_title("Edit user")}
			it { should have_link('change', href: 'http://gravatar.com/emails')}
				# if you poke around the Gravatar site, you’ll see that the page 
				# to add or edit images is located at http://gravatar.com/emails, 
				# so we test the edit page 
		end

		describe "with invalid information" do
			before { click_button "Save changes"}

			it {should have_content('error')}
		end

		describe "with valid information" do
			let(:new_name) { "New Name"}
			let(:new_email) { "new@example.com"}
			before do
				fill_in "Name", with: new_name
				fill_in "Email", with: new_email
				fill_in "Password", with: user.password 
				fill_in "Confirm Password", with: user.password
				click_button "Save changes"
			end

			it { should have_title(new_name) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign out', href: signout_path) }
			specify { expect(user.reload.name).to eq new_name }
			specify { expect(user.reload.email).to eq new_email }
			# .RELOAD reloads the user variable from the test database and
				# then verifies that the user's new name and email match the new values
		end
	end

	describe "signup page" do
		# before {visit signup_path}
		# 	it {should have_content('Sign up')}  
		# 	it {should have_title('Ruby on Rails Tutorial Sample App | Sign up')}	

		before {visit signup_path}
		let (:submit) { "Create my account"}

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end
		end

		describe "with valid information" do
			before do
				fill_in "Name", 		with: "Example User"
				fill_in "Email", 		with: "user@example.com"
				fill_in "Password", 	with: "foobar"
				fill_in "Confirmation",	with: "foobar"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before {click_button submit}
				let(:user) {User.find_by(email: "user@example.com")}

				it {should have_link('Sign out')}
				it {should have_title(user.name)}
				it {should have_selector('div.alert.alert-success', text: 'Welcome')}
			end

		end
	end

	# Testing index WITHOUT SEQUENCE AND PAGINATION
		# 


	describe "index" do
		let(:user) { FactoryGirl.create(:user) }
		before(:each) do
			sign_in user
			visit users_path
		end

		it { should have_title('All users') }
		it { should have_content('All users') }

		describe "pagination" do
			before(:all) { 30.times {FactoryGirl.create(:user)} }
			after(:all) { User.delete_all }

			it { should have_selector('div.pagination') }

			it "should list each user" do
				User.paginate(page: 1).each do |user|
					expect(page).to have_selector('li', text: user.name)
				end	
			end
		end

		describe "delete links" do
			it { should_not have_link('delete') }   # Regular user not an admin

			describe "as an admin user" do
				let(:admin) { FactoryGirl.create(:admin) }  # Create an admin user
				before do
					sign_in admin
					visit user_path
				end

				it { should have_link('delete', href: user_path(User.first)) } 
					# Admin user should have 'delete' link
				it "should be able to delete another user" do
					expect do
						click_link('delete', match: :first) # Capybara click on first link it finds
					end.to change(User, :count).by(-1)
				end

				it { should_not have_link('delete', href: user_path(admin)) }  # Admin user should
						                         # NOT see a delete link next to his OWN name
			end
		end
	end	
end
