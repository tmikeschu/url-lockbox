class LinksController < ApplicationController
  before_action :require_login

  def index
  end

  private

  def require_login
    unless current_user
      flash[:error] = "You must be logged in to see that!"
      redirect_to login_path
    end
  end
end
