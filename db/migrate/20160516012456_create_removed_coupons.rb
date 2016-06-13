class CreateRemovedCoupons < ActiveRecord::Migration
  def change
    create_table :removed_coupons do |t|
      t.integer :id_of_coupon
      t.timestamps null: false
    end
  end
end
