class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :email, unique: true
      t.string :registered_to
      t.boolean :deleted, default: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :accounts, :email #We will find accounts using email
  end
end
