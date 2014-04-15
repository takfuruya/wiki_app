class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @user = User.new
      @notes = current_user.notes
      render "home_signed_in"
    end
  end
end
