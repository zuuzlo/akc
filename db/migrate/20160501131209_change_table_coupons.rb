class ChangeTableCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :slug, :string, index: true
  end
end
