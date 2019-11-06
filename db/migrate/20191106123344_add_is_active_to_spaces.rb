class AddIsActiveToSpaces < ActiveRecord::Migration[5.2]
  def change
    add_column :spaces, :is_active, :boolean
  end
end
