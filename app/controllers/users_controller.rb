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
        flash[:success] = "Welcome to the Sample App!"
        redirect_to root_path
        return
      end

      # Failed to sign up
      render 'static_pages/home'
      return
    end

    # Sign in as regular (non-first time) user
    redirect_to root_path

=begin
    @user = User.new(params[:user])
    @user.name = @user.email.split('@')[0]

    if @user.save
      #redirect_to @user
      render 'static_pages/home'
    else
      render 'static_pages/home'#'static_pages/home' # Need to move def create to static_pages_controller
    end
=end
  end
end
