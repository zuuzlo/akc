module CouponsHelper

  def button_link(coupon)
    link_to coupon_link_coupon_url(coupon), class: "btn btn-primary link_button", rel: "nofollow", target: "_blank" do
      capture_haml do
        haml_concat "Shop Now"
        haml_tag 'span.glyphicon.glyphicon-chevron-right'
      end
    end
  end

  def time_left_display(coupon)
    if coupon.time_difference < 1.day
      capture_haml do
        haml_tag 'span.label.label-danger' do
          haml_tag 'span.glyphicon.glyphicon-time'
          haml_concat "Expires in #{coupon.time_left}"
        end
      end
    elsif coupon.time_difference < 3.day

      capture_haml do
        haml_tag 'span.label.label-warning' do
          haml_tag 'span.glyphicon.glyphicon-time'
          haml_concat "Expires in #{coupon.time_left}"
        end
      end
    else
      capture_haml do
        haml_tag 'span.label.label-success' do
          haml_tag 'span.glyphicon.glyphicon-time'
          haml_concat "Expires in #{coupon.time_left}"
        end
      end
    end  
  end

  def coupon_type(coupon)
    if coupon.code
      'coupon_codes'
    else
      'offers'
    end
  end

  def favorites(controller, coupon)
    if current_user.coupon_ids.include?(coupon.id)
      link_to toggle_favorite_coupon_path(coupon, coupon_id: coupon.id), method: 'post', remote: true, id: "toggle_favorite_#{coupon.id}", class: "btn btn-default btn-xs fav_toggle", "data-toggle" => "tooltip", "data-placement" => "left", "title" => "remove from favorites" do
        capture_haml do
          haml_tag 'span.glyphicon.glyphicon-heart'
        end
      end
    else
      link_to toggle_favorite_coupon_path(coupon, coupon_id: coupon.id), method: 'post', remote: true, id: "toggle_favorite_#{coupon.id}", class: "btn btn-default btn-xs fav_toggle", "container" => 'body', "data-toggle" => "tooltip", "data-placement" => "left", "title" => "add to favorites" do
        capture_haml do
          haml_tag 'span.glyphicon.glyphicon-heart-empty'
        end
      end
    end
  end

  def product_image(coupon)
    
    if coupon.image
      image_tag("#{coupon.image}", size: "125x125", class: "img-circle", alt: "#{coupon.title}")
    else
      image_tag( "#{coupon.store_image}",size: "125x125", alt: "#{coupon.title}" )
    end
  end

  def email_coupon(coupon)
    button_tag(nil, class: "btn btn-default btn-xs email_tool_tip", id: "coupon_email_button_#{coupon.id}", "data-toggle" => "modal", "data-target" => "#coupon_modal_#{coupon.id}", "container" => 'body', "rel" => "tooltip", "data-placement" => "right", "title" => "email coupon") do
      capture_haml do
        haml_tag "span.glyphicon.glyphicon-envelope"
      end
    end
  end

  def not_released(coupon)
    capture_haml do
      haml_tag 'span.label.label-info' do
        haml_tag 'span.glyphicon.glyphicon-time'
        haml_concat "Valid in #{coupon.time_til_good}"
      end
    end
  end

  def cache_key_for_coupon(coupon)
    count          = Coupon.count
    max_updated_at = Coupon.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "coupons/#{coupon.id}-#{count}-#{max_updated_at}"
  end

  def show_ad?
    prng = Random.new

    if prng.rand(100) < 5
      true
    else
      false
    end
  end

  def category_links(coupon)
    render coupon.kohls_categories + coupon.kohls_types + coupon.kohls_onlies
  end

  def reveal_code_button(coupon)
    link_to reveal_code_link_coupon_url(coupon), method: 'get', remote: true, class: "btn btn-default btn-xs", id: "coupon_reveal_button_#{coupon.id}", rel: "nofollow" do
      #, onclick: "window.open('#','_blank');"
      capture_haml do
        haml_concat "Reveal Code"
      end
    end

=begin    
    link_to reveal_code_link_coupon_url(coupon), class: "btn btn-default btn-xs", id: "coupon_reveal_button_#{coupon.id}", rel: "nofollow", target: "_blank", "data-toggle" => "modal", "data-target" => "#coupon_reveal_modal_#{coupon.id}" do
      capture_haml do
        haml_concat "Reveal Code"
      end
    end
#=end
=begin
    button_tag(nil, class: "btn btn-default btn-xs", id: "coupon_reveal_button_#{coupon.id}", "data-toggle" => "modal", "data-target" => "#coupon_reveal_modal_#{coupon.id}", "container" => 'body') do
      capture_haml do
        haml_concat "Reveal Code"
      end
    end
=end
  end
end
