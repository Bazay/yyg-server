class CreateLicences < ActiveRecord::Migration
  def change
    create_table :licences do |t|
      t.references :account
      t.string :key
      t.datetime :expires_at
      t.datetime :expired_at
      t.string :licence_state
      t.string :licence_type
      t.references :licence

      t.timestamps
    end
    add_index :licences, :account_id
    add_index :licences, :licence_id
  end
end
