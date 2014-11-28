class CreateLicences < ActiveRecord::Migration
  def change
    create_table :licences do |t|
      t.references :account
      t.references :product
      t.references :sub_product
      t.string :key, unique: true
      t.datetime :expires_at
      t.datetime :expired_at
      t.datetime :activated_at
      t.datetime :revoked_at
      t.string :licence_state
      t.string :licence_type
      t.boolean :deleted, default: false
      t.datetime :deleted_at

      t.timestamps
    end
    
    add_index :licences, :account_id
    add_index :licences, :product_id
    add_index :licences, :sub_product_id
    add_index :licences, :key #We will call Licence.find_by_key(key) to lookup licences...
  end
end
