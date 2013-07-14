class AddNameAndPublicIdToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :name, :string
    add_column :notes, :public_id, :string
    add_index :notes, :public_id
  end
end
