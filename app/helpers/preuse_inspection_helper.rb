module PreuseInspectionHelper
  def takedown_partial_if_exists(f)
    if @inspection.takedown
      render partial: "takedown", locals: {f:f, takedown: @inspection.takedown}
    end
  end

  def updated_by_div(object)
    unless object.users == []
      "<div id=\"updated-by\">
        Updated by:<br>
        #{updaters_listed(object)}
      </div>".html_safe
    end
  end

  # li for each updater with their name
  def updaters_listed(object)
    object.users.collect do |user|
      user.fullname + '<br>'
    end.join
  end

  def show_inspection_if_selected
    if @inspection
      render partial: "preuse_inspection", locals: {inspection: @inspection}
    else
      text = <<-HTML
        <p>
          No preuse inspection has been logged for that date.
          To create one, click
        </p>
      HTML
      text.html_safe.insert(105, link_to("here", "/elements/#{@element.id}/preuse_inspections?date=#{@date}", method: :post))
    end
  end
end
