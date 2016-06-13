class CreateKohlsTypes < ActiveRecord::Migration
  def change
    create_table :kohls_types do |t|

      t.timestamps null: false
    end
  end
end
