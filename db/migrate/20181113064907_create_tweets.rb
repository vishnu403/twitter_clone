class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweet do |t|
      t.string :content
      t.integer :account_id

      t.timestamps null: false
    end
  end
end
