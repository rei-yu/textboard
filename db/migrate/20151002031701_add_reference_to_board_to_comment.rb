class AddReferenceToBoardToComment < ActiveRecord::Migration
  def change
    add_column :comments, :board_id, :integer
  end
end
