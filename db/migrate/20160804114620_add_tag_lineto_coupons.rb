class AddTagLinetoCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :tagline, :string
  end
end
