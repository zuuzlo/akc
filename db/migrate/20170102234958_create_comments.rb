class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment
      t.integer :commentable_id
      t.string :commentable_type
      t.string :name
      t.string :email
      t.string :website

      t.timestamps null: false
    end
  end
end
