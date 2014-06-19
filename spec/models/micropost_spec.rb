require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  before do 
  	# This code is not idiomatically correct. Works but not rails way
		# Should use ActiveRecord associations between classes (tables)
  	@micropost = Micropost.new(content: "Lorem ipsum", user_id: user.id)
  end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }

  it { should be_valid }  # Using the '.valid?' method that exists for @micropost

  describe "when user_id is not present" do
  	before { @micropost.user_id = nil }
  	it { should_not be_valid }
  		# Need to have 'validates :user_id, presence: true' in app/models/micropost.rb
  			# If don't then @microposts will be valid with user_id = nil
  end
end
