def set_current_user(a_user=nil)
  @request.env["devise.mapping"] = Devise.mappings[:user]
  user = a_user || Fabricate(:user)
  user.confirm # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
  sign_in user
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def set_admin_user(a_user=nil)
  user = a_user || Fabricate(:user)
  set_current_user(user)
  user.admin = true
  user.save
end