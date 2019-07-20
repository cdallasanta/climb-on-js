class PeriodicInspectionsController < ApplicationController
  before_action :check_for_element_and_periodic_existance
  # before_action :check_for_previous_periodic_on_that_date, :remove_empty_comments, only: [:create, :update]

  # /elements/:element_id/periodic_inspections/new
  def new
    @inspection = PeriodicInspection.new(element: @element, date:Date.today)
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

  # /elements/:element_id/periodic_inspections/:id
  def show
    # @inspection is set in the before_action, check_for_element_and_inspection
    render json: @inspection, message: "Inspection logged successfully"
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
      render json: @inspection
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

  def check_for_previous_periodic_on_that_date
    previous_inspection = PeriodicInspection.find_by(date: params[:periodic_inspection][:date], element:@element.id)
    if previous_inspection != @inspection
      flash[:alert] = "There is already an inspection logged for that date. View/edit it <a href='#{edit_element_periodic_inspection_path(@element, previous_inspection)}'>here</a>"
      if @inspection
        render :edit and return
      else
        redirect_to new_element_periodic_inspection_path(@element) and return
      end
    end
  end

  def remove_empty_comments
    params[:periodic_inspection][:comments_attributes].delete_if do |num, comment|
      comment[:content] == ""
    end
  end
end
