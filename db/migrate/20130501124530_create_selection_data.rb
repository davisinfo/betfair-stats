class CreateSelectionData < ActiveRecord::Migration
  def change
    create_table :selection_data do |t|
      t.references :market_selection
      t.integer :order_index
      t.decimal :total_amount_matched, :precision => 8, :scale => 2
      t.decimal :last_price_matched, :precision => 8, :scale => 2

      t.timestamps
    end
    add_index :selection_data, :market_selection_id
  end
end
