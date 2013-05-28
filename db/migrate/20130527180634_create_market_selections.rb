class CreateMarketSelections < ActiveRecord::Migration
  def change
    create_table :market_selections do |t|
      t.references :market
      t.references :selection

      t.timestamps
    end
    add_index :market_selections, :market_id
    add_index :market_selections, :selection_id
  end
end
