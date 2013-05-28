class Selection < ActiveRecord::Base
  has_and_belongs_to_many :markets
  attr_accessible :name
end
