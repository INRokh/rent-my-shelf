class RemoveStripIdFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :strip_id, :integer
  end
end
