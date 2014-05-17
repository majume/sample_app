require 'spec_helper'

describe "StaticPages" do
  # describe "Home page" do
  #   it "should have the content 'Sample App' " do
  #     visit root_path
  #     expect(page).to have_content('Sample App')
  #   end

  #   it "should have the base title" do
  #     visit root_path
  #     expect(page).to have_title("Ruby on Rails Tutorial Sample App")
  #   end

  #   it "should not have the custom title" do
  #     visit root_path
  #     expect(page).not_to have_title('| Home')
  #   end

  # TO REDUCE DUPLICATION
  # 'visit root_path' method before each 'it' example
  # A call to "should" will always reference "page"
          # When used with 'subject', expect(page).to becomes 'should'
    
  subject {page} 
  describe "Home page" do

    before {visit root_path}  
    it {should have_content('Sample App') }
    it {should have_title("Ruby on Rails Tutorial Sample App")}
    it {should_not have_title('| Home')}

  end

  describe "Help page" do
  	it "should have the content 'Help' " do
  		visit help_path
  		expect(page).to have_content('Help')
  	end

    it "should have the right title" do
      visit help_path
      expect(page).to have_title("Ruby on Rails Tutorial Sample App | Help")
    end
  end

  describe "About page" do
    it "should have the content 'About us'" do
      visit about_path
      expect(page).to have_content('About Us')
    end

    it "should have the right title" do
      visit about_path
      expect(page).to have_title("Ruby on Rails Tutorial Sample App | About")
    end
  end

  describe "Contact Page" do
    it "should have the content 'Contact'" do
      visit contact_path
      # expect(page).to have_content("Contact")
      expect(page).to have_selector('h1', text: 'Contact')
    end

    it "should have the title 'Contact" do
      visit contact_path
      expect(page).to have_title("Ruby on Rails Tutorial Sample App | Contact")
      
    end
    
  end

end
