require 'spec_helper'

describe "Authentication" do
  subject {page}

  describe "signin page" do
    before {visit signin_path}

  	describe "with invalid information" do
  		before {click_button "Sign in"}

  		# it {should have_content('Sign in')}
  		it {should have_selector('h1', text: 'Sign in')}
  		it {should have_title('Sign in')}
  		it {should have_selector('div.alert.alert-error')}

  		describe "after visiting another page" do
  			before {click_link "Home"}

  			it {should_not have_selector('div.alert.alert-error')}
  		end
  	end 

  	describe "with valid information" do
  		let(:user) {FactoryGirl.create(:user)}
  		before do
  			fill_in "Email", with: user.email.upcase
  			fill_in "Password", with: user.password 
  			click_button "Sign in"
  		end

  		it {should have_title(user.name)}
  		it {should have_link('Profile', href: user_path(user))}
      it { should have_link('Settings', href: edit_user_path(user))}
  		it {should have_link('Sign out', href: signout_path)}
      it { should have_link('Users', href: users_path) }
  		it {should_not have_link('Sign in', href: signin_path)}

      describe "followed by signout" do
        before {click_link "Sign out"}
        
        it {should have_link('Sign in')}
      end
  	end
  end

  describe "authorization" do
    describe "for non-signed-in users" do
       let(:user) { FactoryGirl.create(:user) } 
       # User created but not signed in. 
       # sign_in function in app/helpers/sessions_helper.rb

       describe "in the Users controller" do
          describe "visiting the edit page" do
            before {visit edit_user_path(user) }
            it { should have_title('Sign in')}
          end

          describe "submitting to the update action" do
            before { patch user_path(user) }
            specify { expect(response).to redirect_to(signin_path)}
              # DIRECT REQUEST: Introduces a second way, apart from Capybara’s
              # visit method, to access a controller action: by issuing the appropriate HTTP
              # request directly, in this case using the patch method to issue a PATCH request:
              # This issues a PATCH request directly to /users/1, which gets routed to the
              # update action of the Users controller. This is necessary because
              # there is no way for a browser to visit the update action directly—it can only
              # get there indirectly by submitting the edit form—so Capybara can’t do it either.
              # IF TRY VISIT EDIT PAGE AND NOT SIGNED IN -AS HERE- CODE PUSHES YOU TO
              # SIGN IN PAGE AND THEREFORE CAN'T TEST ANYTHING ON EDIT PAGE (DON'T REACH IT)
              # THEREFORE CAN'T USE THE 'CLICK-BUTTON SAVE CHANGES' TO GET TO CREATE - NEVER
              # GET TO THE BUTTON TO CLICK IT As a result, the only way to test the proper authorization for
              # the update action itself is to issue a direct request. (As you might guess, in
              # addition to patch Rails tests support get, post, and delete as well.)
              # When using one of the methods to issue HTTP requests directly, we get
              # access to the low-level response object. Unlike the Capybara page object,
              # response lets us test for the server response itself, in this case verifying that
              # the update action responds by redirecting to the signin page:
          end

          describe "visiting the user index" do
            before { visit users_path}
            it { should have_title('Sign in')}
          end
       end

       describe "when attempting to visit a protected page" do
         before do
          visit edit_user_path(user)  # Want to get to the edit page (example of protected page)
          fill_in "Email", with: user.email  # Redirected to sign in - so fill it out
          fill_in "Password", with: user.password
          click_button "Sign in"  # Click sign in button. No want to be redirected to edit
         end
         describe "after signing in" do
           it "should render the desired protected page" do
            expect(page).to have_title('Edit user')  # Check to see if went to edit page
           end
         end
       end
    end

    describe "as wrong user" do
      # The original user should not have access to the wrong users edit or update actions
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) {FactoryGirl.create(:user, email: "wrong@example.com") }
        # Creates a second user with a different email address
       before {sign_in user, no_capybara: true}


      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        # specify { expect(response.body).not_to match(full_title('Edit user')) }
          # I didn't create the full_title method
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end

    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end
