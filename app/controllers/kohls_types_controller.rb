class KohlsTypesController < ApplicationController
  include LoadCoupons
  include LoadSeo

  def show
    @ktype = KohlsType.friendly.find(params[:id])
    load_all_coupons(@ktype)
    render 'shared/display_coupons', locals: { title: @ktype, meta_keywords: seo_keywords(@coupons, @ktype), meta_description: seo_description(@coupons, @ktype)}
  end
end
