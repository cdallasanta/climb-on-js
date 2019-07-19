class PeriodicInspectionSerializer < ApplicationSerializer
  attributes :id, :date, :equipment_complete?, :element_complete?, :environment_complete?, :alert
  
  has_many :comments
end
