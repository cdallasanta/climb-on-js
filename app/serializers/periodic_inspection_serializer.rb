class PeriodicInspectionSerializer < ActiveModel::Serializer
  attributes :id, :equipment_complete, :element_complete, :envionment_complete
  has_many :comments
end
