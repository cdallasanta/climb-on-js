class PreuseInspectionsController < ApplicationController
  before_action :check_logged_in

  def create
    @inspection = PreuseInspection.find_or_create_todays_inspection(params[:element_id])
    @inspection.setup = PreuseInspection::Setup.create if @inspection.setup == nil

    if @inspection.valid?
      redirect_to element_preuse_inspection_path(@inspection.element, @inspection)
    else
      flash[:alert] = "Element not found"
      render elements_path
    end
  end

  # currently, no #new is needed, TODO remove route from config

  def show
    @inspection = PreuseInspection.find_by(id: params[:id])
    @element = @inspection.element
    #TODO check for url schenanegains for both element and inspection

    if @inspection.setup.is_complete?
      @inspection.takedown ||= PreuseInspection::Takedown.create
    end
  end

  def edit
  end

  def update
    binding.pry
    #updating preuse (just the date, really)
    preuse = PreuseInspection.find_by(id: params[:id])
    preuse.date = preuse_params[:date]
    #save preuse for date validation
    unless preuse.save
      render element_preuse_inspection_path(preuse.element, preuse)
    end

    #updating setup
    setup = preuse.setup
    setup.update(preuse_params[:preuse_inspection_setup])
    setup.users << current_user unless setup.users.include?(current_user)

    #updating takedown
    #more to come

    #TODO flash message for success? also check for other errors, like form editing?
    redirect_to element_preuse_inspection_path(preuse.element, preuse)
  end

  private

  def preuse_params
    params.require(:preuse_inspection).permit(
      :date,
      preuse_inspection_setup:
        [:equipment_complete, :element_complete, :environment_complete]
      )
  end
end
