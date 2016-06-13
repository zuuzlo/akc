class ChangeTable < ActiveRecord::Migration
  change_table :coupons do |t|
    t.string :image
  end
end
