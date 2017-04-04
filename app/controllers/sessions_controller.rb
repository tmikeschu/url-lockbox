class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:success] = "Login successful!"
      redirect_to links_path
    else
      message = @user ? "incorrect password" : "email not found"
      flash.now[:error] = "Sorry, #{message}"
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to login_path
  end
end
