class KohlsOnliesController < ApplicationController
  include LoadCoupons
  include LoadSeo

  def show
    @category = KohlsOnly.friendly.find(params[:id])
    load_all_coupons(@category)
    render 'shared/display_coupons', locals: { title: @category, meta_keywords: seo_keywords(@coupons, @category), meta_description: seo_description(@coupons, @category)}
  end

end
