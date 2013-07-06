class MarketSelection < ActiveRecord::Base
  belongs_to :market
  belongs_to :selection
  has_many :selection_values
  # attr_accessible :title, :body
end
