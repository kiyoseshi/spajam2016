class AddUserTypeToChats < ActiveRecord::Migration
  def change
    add_column :chats, :user_type, :string
  end
end
