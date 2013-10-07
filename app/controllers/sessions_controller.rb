class SessionsController < ApplicationController
  before_action :session_params, only: [:create, :destroy]
  skip_before_action :authenticate, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by_username session_params[:username]
    if user and user.authenticate session_params[:password]
      session[:user_id] = user.id
      redirect_to user_path user
    else
      redirect_to sessions_new_path, alert: 'Invalid username/password'
    end
  end

  def destroy
    session[:user_id] = nil

    redirect_to sessions_new_path, notice: 'Logged out'
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def session_params
    params.permit(:username, :password)
  end
end
