class PeriodicInspectionSerializer < ActiveModel::Serializer
  attributes :id, :date, :equipment_complete?, :element_complete?, :environment_complete?
  
  has_many :comments
end
