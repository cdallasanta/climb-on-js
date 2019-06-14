class Element < ApplicationRecord
  belongs_to :site
  has_many :ropes, class_name: "Element::Rope"
  has_many :preuse_inspections, class_name: "Inspection::PreuseInspection"
  has_many :periodic_inspections, class_name: "Inspection::PeriodicInspection"
  accepts_nested_attributes_for :ropes

  validates_presence_of :name
  validates_presence_of :site

  after_initialize :set_default_instructions

  #TODO figure out how to deal with default instructions.
  @@DEFAULT_INSRUCTIONS = {
    setup_equipment_instructions: "All gear checked<br>Bad gear set aside",
    setup_element_instructions: "Everything appears normal<br>Backup halos not engaged",
    setup_environment_instructions: "Weather is appropriate for climbing<br>No widowmakers",
    takedown_equipment_instructions: "Gear stored properly<br>Helmets sprayed",
    takedown_element_instructions: "Access methods removed",
    takedown_environment_instructions: "Area clear of garbage",
    periodic_equipment_instructions: "filler",
    periodic_element_instructions: "filler",
    periodic_environment_instructions: "filler"
  }

  def set_default_instructions
    #TODO, this is filler until I work on elements/new
    self.setup_equipment_instructions ||= @@DEFAULT_INSRUCTIONS[:setup_equipment_instructions]
    self.setup_element_instructions ||= @@DEFAULT_INSRUCTIONS[:setup_element_instructions]
    self.setup_environment_instructions ||= @@DEFAULT_INSRUCTIONS[:setup_environment_instructions]
    self.takedown_equipment_instructions ||= @@DEFAULT_INSRUCTIONS[:takedown_equipment_instructions]
    self.takedown_element_instructions ||= @@DEFAULT_INSRUCTIONS[:takedown_element_instructions]
    self.takedown_environment_instructions ||= @@DEFAULT_INSRUCTIONS[:takedown_environment_instructions]
    self.periodic_equipment_instructions ||= @@DEFAULT_INSRUCTIONS[:periodic_equipment_instructions]
    self.periodic_element_instructions ||= @@DEFAULT_INSRUCTIONS[:periodic_element_instructions]
    self.periodic_environment_instructions ||= @@DEFAULT_INSRUCTIONS[:periodic_environment_instructions]
    self.save
   end

  def date_of_last_periodic
    #TODO make this
  end

  def update_ropes(params)
    element = self
    params.each do |rope_num, rope_details|
      if rope_details[:id]
        old_rope = element.ropes.find_by(id: rope_details[:id])
        if old_rope.identifier != rope_details[:identifier]
          old_rope.update(retired: true)
          element.ropes.create(identifier: rope_details[:identifier])
        end
      elsif rope_details[:identifier]
        element.ropes.create(identifier: rope_details[:identifier])
      end
    end
  end
end
