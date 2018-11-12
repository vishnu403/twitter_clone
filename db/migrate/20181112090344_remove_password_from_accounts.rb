class RemovePasswordFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :password, :string
  end
end
