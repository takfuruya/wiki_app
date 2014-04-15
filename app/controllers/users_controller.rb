class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:update, :destroy]
  before_filter :correct_user,   only: :update
  before_filter :admin_user,     only: :destroy

  def index
    @users = User.all
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:top_message] = "User destroyed."
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
        # Sign up & sign in as first time user.
        sign_in @user
        flash[:success] = "You are signed up!"
        redirect_to root_path
      else
        # Failed to sign up.
        email_errors = @user.errors.get(:email)
        password_errors = @user.errors.get(:password)
        password_confirmation_errors = @user.errors.get(:password_confirmation)
        if email_errors && email_errors.any?
          if email_errors[0] == "can't be blank"
            flash[:email_error] = "Please fill this in. Thank you."
          elsif email_errors[0] == "is invalid"
            flash[:email_error] = "Sorry, this is invalid."
          elsif email_errors[0] == "has already been taken"
            flash[:email_error] = "Sorry, this is already registered."
          end
        end
        if password_errors && password_errors.any?
          if password_errors[0] == "is too short (minimum is 6 characters)"
            flash[:password_error] = "This needs minimum of 6 characters."
          elsif password_errors[0] == "doesn't match confirmation"
            flash[:password_error] = "Sorry, this does not match the confirmation."
          end
        end
        if password_confirmation_errors && password_confirmation_errors.any?
          if password_confirmation_errors[0] == "can't be blank"
            flash[:password_confirmation_error] = "Please fill this in. Thank you."
          else
            flash[:password_confirmation_error] = password_confirmation_errors[0]
          end
        end
        flash[:email] = @user.email
        flash[:is_new_user] = true
        redirect_to root_path
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
      if params[:email] == ""
        flash[:email_error] = "Please fill this in. Thank you."
      elsif params[:password] == ""
        flash[:password_error] = "Please fill this in. Thank you."
      else
        flash[:email_error] = "Sorry, we do not recognize this email-password combination."
      end
      flash[:email] = params[:email]
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
      flash[:top_message] = "Profile updated"
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
