class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
    # AUTHORIZATION: Making sure that user is signed in,by running the 
      # signed_in_user function (private function below) before  'edit', and 'update' actions
  before_action :correct_user, only: [:edit, :update]

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def edit
    # @user = User.find(params[:id])  Don't need as done in 'correct_user' below
  end

  def update
    # @user = User.find(params[:id])  Don't need as done in 'correct_user' below

    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
      # About update_attributeS
        # The update_attributeS method accepts a hash of attributes, and on success
        # performs both the update and the save in one step (returning true to indicate
        # that the save went through). Note that if any of the validations fail, such as
        # when a password is required to save a record (as implemented in Section 6.3),
        # the call to update_attributes will fail. If we only need to update a single
        # attribute, using the SINGULAR update_attribute bypasses this restriction:
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to the Sample App"
  		redirect_to @user  # Assumes user_path @user as no other GET <something> :id path
  	else
  		render 'new'
  	end
  end

  private
  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

    def signed_in_user
      unless signed_in?
        flash[:notice] = "Please sign in."
        redirect_to signin_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        redirect_to(root_url)
      end
    end
end
