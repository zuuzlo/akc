class CreateKohlsOnlies < ActiveRecord::Migration
  def change
    create_table :kohls_onlies do |t|
      t.string :name
      t.integer :kc_id
      t.string :slug
      t.string :image
      t.timestamps null: false
    end
  end
end
