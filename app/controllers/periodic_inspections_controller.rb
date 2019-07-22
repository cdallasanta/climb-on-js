class PeriodicInspectionsController < ApplicationController
  before_action :check_for_element_and_periodic_existance

  # /elements/:element_id/periodic_inspections/new
  def new
    @inspection = PeriodicInspection.find_or_create_by(element: @element, date:Date.today)
    if PeriodicInspection.find_by(element: @element, date:Date.today)
      redirect_to edit_periodic_inspection_path()
    end
    @inspection.comments.build(user:current_user)
  end

  def create
    @inspection = PeriodicInspection.new(element: @element)

    # TODO, something about the statement below doesn't pass the code smell
    # if the inspection will change when saved, add the current user to be referenced by
    # 'edited by', and also reduce the number of calls to the db
    @inspection.assign_attributes(periodic_params)

    if @inspection.changed_for_autosave?
      if @inspection.comments.last
        @inspection.comments.last.user = current_user unless @inspection.comments.last.user
      end

      if @inspection.save
        @inspection.users << current_user unless @inspection.users.include?(current_user)
        render json: @inspection, message: "Inspection logged successfully", status: 201
      else
        render partial: 'application/errors', locals: {object: @inspection, alert_type: "alert-danger", message: "Error:"}, status: 422
      end
    end
  end

  # /elements/:element_id/periodic_inspections/:date
  def show
    @inspection = PeriodicInspection.find_by(date: params[:date])
    if @inspection
      render json: @inspection, message: "There is an inspection already logged for that date. Loaded below."
    else
      render json: @inspection, status: 404
    end
  end

  # /elements/:element_id/periodic_inspections/:id/edit
  def edit
    # @inspection is set in the before_action, check_for_element_and_inspection
    @inspection.comments.build(user:current_user)
  end

  def update
    @inspection.assign_attributes(periodic_params)

    if @inspection.changed_for_autosave?
      if @inspection.comments.last
        @inspection.comments.last.user = current_user unless @inspection.comments.last.user
      end

      if @inspection.save
        @inspection.users << current_user unless @inspection.users.include?(current_user)
        render json: @inspection, message: "Inspection updated successfully", status: 201
      else
        render partial: 'application/errors', locals: {object: @inspection, alert_type: "alert-danger", message: "Error:"}, status: 422
      end
    else
      # TODO, if there's not change?
      render json: @inspection, message: "Inspection updated successfully", status: 201
    end
  end

  private

  def periodic_params
    params.permit(
      :date,
      :equipment_complete,
      :element_complete,
      :environment_complete,
      comments_attributes: [
        :content
      ]
    )
  end

  # stopping url shenanigans, and also setting instance variables
  def check_for_element_and_periodic_existance
    @element = Element.find_by(id:params[:element_id])
    if @element
      if params[:id]
        @inspection = @element.periodic_inspections.find_by(id: params[:id])
        if @inspection.nil?
          flash[:alert] = "Inspection id not found under that element"
          redirect_to element_path(@element)
        end
      end
    else
      flash[:alert] = "No element found with that id"
      redirect_to root_path
    end
  end
end
