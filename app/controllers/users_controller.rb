class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]

  def index
    if current_user_admin?
      @users = User.by_name
    else
      @users = User.not_admins
    end
  end

  def show
    @reviews = @user.reviews
    @favourite_movies = @user.favourite_movies
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thanks for signing up!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Account successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    # Only clear the session user id if the user is deleting their own account
    # This was not in the exercise but noticed when I was testing an admin
    # deleting an account - it also signed the admin out!
    session[:user_id] = nil if @user.id == session[:user_id]
    redirect_to root_path, alert: "Account successfully deleted!"
  end

  private

  def require_correct_user
    redirect_to root_url unless current_user?(@user)
  end

  def user_params
    params.require(:user)
          .permit(:name, :username, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find_by!(username: params[:id])
  end
end
