class CreateCouponKohlsCategories < ActiveRecord::Migration
  def change
    create_table :coupon_kohls_categories do |t|
      t.belongs_to :coupon, :null => false, :index => true
      t.belongs_to :kohls_category, :null => false, :index => true
      t.timestamps null: false
    end
  end
end
