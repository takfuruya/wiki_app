class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def create
    if params[:sign_up?]
      @user = User.new
      @user.email = params[:email]
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      @user.name = @user.email.split('@')[0] if !@user.email.nil?

      if @user.save
        # Sign in as first time user
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to root_path
      else
        # Failed to sign up
        render 'static_pages/home'
      end

      return
    end

    # Sign in as regular (non-first time) user
    user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_to root_path
    else
      flash[:error] = 'Invalid email/password combination'
      redirect_to root_path
    end
  end

  def signout
    sign_out
    redirect_to root_url
  end
end
