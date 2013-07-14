class StaticPagesController < ApplicationController
  def home
    @user = User.new
    if signed_in?
      @notes = current_user.notes
      render "home_signed_in"
    end
  end
end
