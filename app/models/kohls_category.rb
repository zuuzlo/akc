class KohlsCategory < ActiveRecord::Base

  has_many :coupon_kohls_categories
  has_many :coupons, :through => :coupon_kohls_categories

  validates :name, presence: true
  validates :slug, presence: true
  validates :kc_id, uniqueness: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  def self.with_coupons
    KohlsCategory.joins(:coupons).where(["end_date >= :time", { :time => DateTime.current }]).uniq.order( 'name ASC' )
  end
end
