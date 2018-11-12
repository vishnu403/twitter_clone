class AddBioToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :bio, :string
  end
end
