class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :id_of_coupon
      t.text :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.string :code
      t.text :restriction
      t.text :link
      t.text :impression_pixel

      t.timestamps null: false
    end
  end
end
