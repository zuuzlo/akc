module ApplicationHelper
  
  def filt_page?
    if ['kohls_categories', 'kohls_types', 'kohls_onlies'].include?(params[:controller])
      true
    else
      false
    end
  end

  def user_home?
    if params[:id]
      param = "id"
    else
      param = "user_id"
    end

    if params[param.to_sym] == current_user.slug
      true
    else
      false
    end
  end
end
