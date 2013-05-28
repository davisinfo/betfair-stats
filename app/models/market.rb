class Market < ActiveRecord::Base
  attr_accessible :country_iso3, :event_type_id, :name, :number_of_winners, :path, :selections_no, :status, :suspend_time, :time, :type, :type_name, :type_variant
  set_inheritance_column "type2"
  
  has_and_belongs_to_many :selections
end
