class CreateTableCouponKohlsOnlies < ActiveRecord::Migration
  def change
    create_table :coupon_kohls_onlies do |t|
      t.belongs_to :coupon, :null => false, :index => true
      t.belongs_to :kohls_only, :null => false, :index => true
      t.timestamps null: false
    end
  end
end
