class AddAttachmentImageToAccounts < ActiveRecord::Migration
  def self.up
    change_table :accounts do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :accounts, :image
  end
end
