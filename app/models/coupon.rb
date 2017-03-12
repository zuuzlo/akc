class Coupon < ActiveRecord::Base
  require 'action_view'
  include ActionView::Helpers::DateHelper

  NULL_ATTRS = %w( code restriction )
  
  before_save :nil_if_blank

  has_many :coupon_kohls_types, dependent: :destroy
  has_many :kohls_types, :through => :coupon_kohls_types

  has_many :coupon_kohls_categories, dependent: :destroy
  has_many :kohls_categories, :through => :coupon_kohls_categories
  
  has_many :coupon_kohls_onlies, dependent: :destroy
  has_many :kohls_onlies, :through => :coupon_kohls_onlies

  has_many :comments, as: :commentable, dependent: :destroy

  validates :id_of_coupon, presence: true, uniqueness: true
  validates :title, presence: true
  validates :link, presence: true
  validates :slug, presence: true

  mount_uploader :image, CouponImageUploader

  extend FriendlyId
  friendly_id :title, use: :slugged

  def time_left
    if end_date
      distance_of_time_in_words(end_date, DateTime.now)
    else
      "No End Date"
    end
  end

  def self.active_coupons
    where(["end_date >= :time", { :time => DateTime.current }]).order( 'end_date ASC' )
  end

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("lower(description) LIKE ?", "%#{search_term.downcase}%")
  end

  def preview?
    if start_date > DateTime.now
      true
    else
      false
    end
  end

  def time_til_good
    distance_of_time_in_words(start_date, DateTime.now)
  end

  def time_difference
    end_date - DateTime.now
  end

  protected

  def nil_if_blank
    NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? }
  end
end
