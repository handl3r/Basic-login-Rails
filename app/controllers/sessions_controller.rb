class SessionsController < ApplicationController
  before_action :require_logged_out, only: [:new]

  def new; end

  def create
    user = User.find_by name: params[:session][:name]
    if user&.authenticate(params[:session][:password])
      log_in user
      if params[:session][:remember_me] == '1'
        remember user
      else
        forget user
      end
      redirect_to root_url
    else
      flash.now[:danger] = 'Invalid name or password'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def require_logged_out
    unless !logged_in?
      flash[:error] = 'You must be logged out before logging in'
      redirect_to root_url
    end
  end
end
