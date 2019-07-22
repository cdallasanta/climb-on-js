class PeriodicInspectionSerializer < ActiveModel::Serializer
  attributes :id, :date, :equipment_complete?, :element_complete?, :environment_complete?, :alert
  
  has_many :comments
  has_many :users

  def alert
    ApplicationController.new.render_to_string(partial: 'application/errors', locals: {object: object, alert_type: "alert-success", message: @instance_options[:message]})
  end
end
