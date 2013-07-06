class RenameSelectionDataToSelectionValue < ActiveRecord::Migration
  def up
    rename_table :selection_data, :selection_values
  end

  def down
    rename_table :selection_values, :selection_data
  end
end
