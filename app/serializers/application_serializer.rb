class ApplicationSerializer < ActiveModel::Serializer
  def alert
    ApplicationController.new.render_to_string(partial: 'application/errors', locals: {object: object, alert_type: "alert-success", message: @instance_options[:message]})
  end
end