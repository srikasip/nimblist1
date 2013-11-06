class SessionsController < ApplicationController
  def new
    if session[:user_id]
      flash[:notice] = 'You are already logged in. If this is not you, then please log out and log back in as a different user.'
      redirect_to tasks_path
    end
  end

  def create
    user = User.find_by_name(params[:name].downcase)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Logged In!"
      redirect_to root_url
    else
      flash[:error] = 'Invalid username or password.'
      redirect_to login_path
    end
  end

  def destroy
    reset_session
    flash[:notice] = "Logged Out!"
    redirect_to root_url
  end
end
