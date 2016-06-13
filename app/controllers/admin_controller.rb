class AdminController < ApplicationController

  helper_method :ensure_admin, :admin?
  before_filter :ensure_admin
  
  def ensure_admin
    if current_user
      if !current_user.admin?
        flash[:danger] = 'You don not have access to Admin area.'
        redirect_to root_path #user_path(current_user)
      end
    else
      flash[:danger] = 'You don not have access to Admin area. Sign in first'
      redirect_to root_path
    end
  end

  def admin?
    current_user.admin
  end
end
