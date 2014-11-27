class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, unique: true
      t.string :product_type
      t.float :base_price
      t.boolean :deleted, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
