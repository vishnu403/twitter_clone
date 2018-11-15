class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.integer :account_id
      t.integer :following_account_id

      t.timestamps null: false
    end
  end
end
