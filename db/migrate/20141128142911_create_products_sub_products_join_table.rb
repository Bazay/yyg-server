class CreateProductsSubProductsJoinTable < ActiveRecord::Migration
  def change
    create_table :products_sub_products, id: false do |t|
      t.integer :product_id
      t.integer :sub_product_id
    end
  end
end
