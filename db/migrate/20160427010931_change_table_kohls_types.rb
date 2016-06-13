class ChangeTableKohlsTypes < ActiveRecord::Migration
  def change
    add_column :kohls_types, :name, :string
    add_column :kohls_types, :slug, :string, index: true
    add_column :kohls_types, :kc_id, :integer
  end
end
