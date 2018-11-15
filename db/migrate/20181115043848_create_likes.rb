class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :account_id
      t.integer :tweet_id

      t.timestamps null: false
    end
  end
end
