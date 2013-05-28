class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.string :name
      t.string :country_iso3
      t.integer :event_type_id
      t.string :status
      t.datetime :suspend_time
      t.datetime :time
      t.string :type
      t.string :type_variant
      t.string :path
      t.string :type_name
      t.integer :selections_no
      t.integer :number_of_winners

      t.timestamps
    end
  end
end
