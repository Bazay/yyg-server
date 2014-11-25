class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :email
      t.string :registered_to
      t.boolean :deleted, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
