class CreateSubProducts < ActiveRecord::Migration
  def change
    create_table :sub_products do |t|
      t.string :name
      t.string :sub_product_type
      t.float :base_price
      t.boolean :deleted, default: false
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :sub_products, :product_id_id
  end
end
