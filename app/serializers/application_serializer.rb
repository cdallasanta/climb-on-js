class ApplicationSerializer < ActiveModel::Serializer
  def alert
    # render partial: 'application/errors', locals: {object: object, alert_type: "alert-success"}
  end
end