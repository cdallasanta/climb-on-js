class Element::Rope::Climb < ApplicationRecord
  self.table_name = "climbs"
  belongs_to :rope, class_name: "Element::Rope"
  belongs_to :takedown, class_name: "PreuseInspection::Takedown"
end