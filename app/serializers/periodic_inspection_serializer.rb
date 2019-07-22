class PeriodicInspectionSerializer < ActiveModel::Serializer
  attributes :id, :date, :equipment_complete?, :element_complete?, :environment_complete?, :alert, :element
  
  has_many :comments
  has_many :users
  belongs_to :element

  def alert
    if @instance_options[:message]
      ApplicationController.new.render_to_string(partial: 'application/errors', locals: {object: object, alert_type: "alert-success", message: @instance_options[:message]})
    end
  end

  class ElementSerializer < ActiveModel::Serializer
    attributes :id
  end
end
