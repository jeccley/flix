class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email_or_username]) ||
           User.find_by(username: params[:email_or_username])

    if user_authenticated?(user, params[:password])
      session[:user_id] = user.id
      redirect_to (session[:intended_url] || user),
                  notice: "Welcome back, #{user.name}!"
      session[:intended_url] = nil
    else
      # Flash is used as we are just reseting the form rather than rendering a page so the usual use of alert would not work
      flash.now[:alert] = "Invalid email/password combination!"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    session[:intended_url] = nil
    redirect_to root_path, notice: "You're now signed out!"
  end

  private

  def user_authenticated?(user, password)
    user && user.authenticate(password)
  end
end
