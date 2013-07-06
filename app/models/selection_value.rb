class SelectionValue < ActiveRecord::Base
  belongs_to :market_selection
  attr_accessible :last_price_matched, :order_index, :total_amount_matched
end
