class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :display_ad?
  
  def display_ad?
    if Rails.env.development?
      false
    else
      
      if user_signed_in?
        false
      else
        true
      end
    end
  end

  def after_destroy_user_session_path_for(resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    root_path
  end
end