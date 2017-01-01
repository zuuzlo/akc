module LoadCoupons
  extend ActiveSupport::Concern

  def load_coupons(title)
    #@coupons = title.coupons.active_coupons
    @coupons = title.coupons.active_coupons.paginate(:page => params[:page]).order( 'end_date ASC' )
    #@coupons = title.coupons.where(["end_date >= :time", { :time => DateTime.current }]).order( 'end_date ASC' )
  end

  def load_coupon_offer_code(coupons)
    @codes_count = coupon_codes(coupons)
    @offers_count = coupon_offers(coupons)
  end

  def load_cal_picts(coupons)
    cals = coupons.collect(&:id).sample(5)
    @cal_coupons = Coupon.find(cals)
  end

  def load_all_coupons(title)
    load_coupons(title)
    #load_coupon_offer_code(@coupons)
    load_coupon_offer_code(title.coupons.active_coupons.all)
    load_cal_picts(@coupons)
  end

  def coupon_codes(coupons)
    codes = 0
    coupons.each do | coupon |
      codes = codes + 1 if coupon.code
    end
    codes
  end

  def coupon_offers(coupons)
    offers = 0
    coupons.each do | coupon |
      offers = offers + 1 unless coupon.code
    end
    offers
  end
end