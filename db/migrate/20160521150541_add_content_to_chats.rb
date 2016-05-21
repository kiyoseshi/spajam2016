class AddContentToChats < ActiveRecord::Migration
  def change
    add_column :chats, :content, :string
  end
end
