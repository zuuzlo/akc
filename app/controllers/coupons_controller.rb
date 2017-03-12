class CouponsController < ApplicationController
  include LoadCoupons
  include LoadSeo

  def index
    @coupons = Coupon.active_coupons.paginate(:page => params[:page]).order( 'end_date ASC' )
    coupons_active = Coupon.active_coupons
    load_coupon_offer_code(coupons_active)
    load_cal_picts(@coupons)
    render :index, locals: { title: "Home", meta_keywords: seo_keywords(@coupons, nil), meta_description: seo_description(@coupons, nil ) } 
  end

  def show
    @coupon = Coupon.friendly.find(params[:id])
    @coupons = Coupon.active_coupons[0..2]
    render :show, locals: { title: "#{@coupon.title}", meta_keywords: seo_keywords(@coupons, nil), meta_description: seo_description(@coupons, nil ) } 
  end

  def search
    @coupons = Coupon.search_by_title(params[:search_term]).paginate(:page => params[:page]).order( 'end_date ASC' )
    @term = params[:search_term]
    load_coupon_offer_code(@coupons)
    load_cal_picts(@coupons)
    render :index, locals: { title: "Search: #{params[:search_term]}", meta_keywords: seo_keywords(@coupons, nil), meta_description: seo_description(@coupons, nil ) } 
  end

  def tab_all
  end

  def tab_coupon_codes
  end

  def tab_offers
  end

  def coupon_link
    if Coupon.friendly.exists?(params[:id])
      coupon = Coupon.friendly.find(params[:id])
    else
      coupon = Coupon.last
    end
    
    link = coupon.link + "&u1=akc"  

    redirect_to link
  end

  def reveal_code_link
    if Coupon.friendly.exists?(params[:id])
      @coupon = Coupon.friendly.find(params[:id])
    else
      @coupon = Coupon.last
    end
 
    respond_to do |format|
      format.html do
      end
      format.js
    end
  end

  def add_comment
    @coupon = Coupon.friendly.find(params[:id])
    respond_to do |format|
      format.html do
      end
      format.js
    end
  end

  def hide_comment
    @coupon = Coupon.friendly.find(params[:id])
    respond_to do |format|
      format.html do
      end
      format.js
    end
  end
  
  private

  def coupon_params
    params.require(:coupon).permit(:slug, :id)
  end
end
