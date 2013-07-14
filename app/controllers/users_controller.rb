class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:update, :destroy]
  before_filter :correct_user,   only: :update
  before_filter :admin_user,     only: :destroy

  def index
    @users = User.all
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def show
    @user = User.find(params[:id])
    @notes = @user.notes
  end

  def create
    if params[:sign_up?] && !signed_in?
      @user = User.new
      @user.email = params[:email]
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      @user.name = @user.email.split('@')[0] if !@user.email.nil?

      if @user.save
        # Sign in as first time user.
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to root_path
      else
        # Failed to sign up.
        render 'static_pages/home'
      end

      return
    end

    # Sign in as regular (non-first time) user.
    if params[:email].nil?
      redirect_to root_url
      return
    end
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

  def update
    @notes = current_user.notes
    @user.name = params[:name]
    @user.email = params[:email]
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]

    if @user.save
      # Handle a successful update.
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to root_url
    else
      # Failed to update user profile.
      render 'static_pages/home_signed_in'
    end
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
