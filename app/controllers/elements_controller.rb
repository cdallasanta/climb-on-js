class ElementsController < ApplicationController

  def index
    @elements = current_site.elements
  end

  def show
    @element = Element.find_by(id: params[:id])

    unless @element
      flash[:alert] = "Element not found"
      render :index
    end
  end

  def edit
    @element = Element.find_by(id: params[:id])

    unless @element
      flash[:alert] = "Element not found"
      render :index
    end
  end

  def update
    @element = Element.find_by(id: params[:id])
    @element.update(string_to_html(element_params.except(:ropes_attributes)))
    @element.update_ropes(element_params[:ropes_attributes])

    if @element.valid?
      flash[:alert] = "Element saved successfully"
      redirect_to element_path(@element)
    else
      render :edit
    end
  end

  private

  def element_params
    params.require(:element).permit(
      :name,
      :setup_equipment_instructions,
      :setup_element_instructions,
      :setup_envvironment_instructions,
      :takedown_equipment_instructions,
      :takedown_element_instructions,
      :takedown_envvironment_instructions,
      :periodic_equipment_instructions,
      :periodic_element_instructions,
      :periodic_envvironment_instructions,
      ropes_attributes: {}
    )
  end

  def string_to_html(params)
    params.to_h.transform_values do |text|
      text.sub("\r\n","<br>")
    end
  end
end
