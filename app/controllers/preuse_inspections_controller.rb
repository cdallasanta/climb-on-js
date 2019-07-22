class PreuseInspectionsController < ApplicationController
  before_action :check_for_element_and_preuse_existance

  def create
    # if the request comes in with a string, it is likely coming from /index, where
    # they selected a date without an inspection, and want to create one
    if params[:date]
      @inspection = @element.find_past_inspection(params[:date])
      # checking for url shenanigans
      if @inspection.nil?
        @inspection = @element.preuse_inspections.create(date:Date.strptime(params[:date], "%Y-%m-%d"))
      else
        redirect_to edit_element_preuse_inspection_path(@element, @inspection)
      end
    # otherwise, they are from /elements and want to log today's inspection
    else
      @inspection = @element.find_or_create_todays_inspection
    end
    @inspection.setup = PreuseInspection::Setup.create if @inspection.setup == nil

    redirect_to edit_element_preuse_inspection_path(@element, @inspection)
  end

  # /elements/:element_id/preuse_inspections
  def index
    # if they selected a date, show the selected inspection in the view
    if params[:date]
      @inspection = PreuseInspection.find_past_inspection(params[:date], @element.id)
      # if no inspection was found, this will allow the view to offer a link to
      # create a new inspection on that date
      if @inspection.nil?
        @date = params[:date]
      end
    end
  end

  # /elements/:element_id/preuse_inspections/:id/edit
  def edit
    @inspection.setup.comments.build(user:current_user)
    if @inspection.setup.is_complete?
      @inspection.takedown ||= PreuseInspection::Takedown.create
      @inspection.takedown.comments.build(user:current_user)
    end
  end

  def update
    #updating preuse (just the date, really)
    @inspection.date = preuse_params[:date]
    #save preuse for date validation, to ensure the date is unique on that element
    unless @inspection.save
      link_to_previous_preuse_on_that_date and return
    end

    remove_empty_comments
    #updating setup
    setup = PreuseInspection::Setup.find_by(id: preuse_params[:setup_attributes][:id])
    if setup == @inspection.setup
      # if the inspection will change when saved, add the current user to be referenced by
      # 'edited by', and also reduced the number of calls to the db
      setup.assign_attributes(preuse_params[:setup_attributes])
      if setup.changed_for_autosave?
        setup.save
        setup.users << current_user unless setup.users.include?(current_user)
        flash[:alert] = "Inspection logged successfully"
      end
    else
      flash[:alert] = "Setup inspection id not found"
      render :edit and return
    end

    #updating takedown
    if preuse_params[:takedown_attributes]
      takedown = PreuseInspection::Takedown.find_by(id: preuse_params[:takedown_attributes][:id])
      if takedown == @inspection.takedown
        # if the inspection will change when saved, add the current user to be referenced by
        # 'edited by', and also reduced the number of calls to the db
        takedown.assign_attributes(preuse_params[:takedown_attributes])
        if takedown.changed_for_autosave?
          takedown.save
          takedown.users << current_user unless takedown.users.include?(current_user)
          flash[:alert] = "Inspection logged successfully"
        end
      else
        flash[:alert] = "Takedown inspection id not found"
        render :edit and return
      end
    end

    # sent to edit instead of show, since it is more likely that
    # they will do more changes soon
    redirect_to edit_element_preuse_inspection_path(@inspection.element, @inspection)
  end

  private

  def preuse_params
    params.require(:preuse_inspection).permit(
      :date,
      setup_attributes: [
        :equipment_complete,
        :element_complete,
        :environment_complete,
        :id,
        comments_attributes: [
          :user_id,
          :content,
          :id
        ]
      ],
      takedown_attributes: [
        :equipment_complete,
        :element_complete,
        :environment_complete,
        :id,
        ropes_attributes: [
          :id,
          climbs_attributes: [
            :number_of_climbs,
            :id
          ]
        ],
        comments_attributes: [
          :user_id,
          :content
        ]
      ]
    )
  end

  # preventing url shenanigans
  def check_for_element_and_preuse_existance
    @element = Element.find_by(id:params[:element_id])
    if @element
      if params[:id]
        @inspection = @element.preuse_inspections.find_by(id: params[:id])
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

  # called if they try to save an inspection for a date that already has
  # an inspection logged
  # TODO, is PreuseInspection.find_past_inspection defined anywhere?
  def link_to_previous_preuse_on_that_date
    previous_inspection = @element.find_past_inspection(params[:preuse_inspection][:date])
    if previous_inspection
      flash[:alert] = "There is already an inspection logged for that date. View/edit it <a href='#{edit_element_preuse_inspection_path(@element, previous_inspection)}'>here</a>"
      redirect_to edit_element_preuse_inspection_path(@element, @inspection)
    end
  end

  def remove_empty_comments
    params[:preuse_inspection][:setup_attributes][:comments_attributes].delete_if do |num, comment|
      comment[:content] == ""
    end

    if params[:preuse_inspection][:takedown_attributes]
      params[:preuse_inspection][:takedown_attributes][:comments_attributes].delete_if do |num, comment|
        comment[:content] == ""
      end
    end
  end
end
