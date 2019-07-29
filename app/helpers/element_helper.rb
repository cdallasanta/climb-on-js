module ElementHelper
  # goes through each non-retired rope, putting out its info
  def rope_details
    @element.ropes.collect do |rope|
        if !rope.retired
        "<div class=\"rope-details\">
          <h3>#{rope.identifier}</h3>
          Total climbs: #{rope.climb_count}<br>
          #{link_to("Retire and replace rope", element_rope_path(@element, rope), method: :patch)}
        </div>"
      end
    end.join.html_safe
  end

  # used to convert the <br> stored in the db to a line break for the textarea
  def html_to_string(text)
    text.gsub("<br>","\n")
  end

  # text field for each non-retired rope
  def ropes_fields(f)
    f.fields_for :ropes do |ff|
      if !ff.object.retired
        ff.text_field(:identifier) + "<br>".html_safe
      end
    end
  end

  # puts date of the last periodic inspection, and a link to view it
  # TODO it's not pretty, but the shoe fits
  def date_of_last_periodic
    if @element.periodic_inspections != []
      inspection = @element.periodic_inspections.order("date").last
      link = link_to inspection.date, edit_element_periodic_inspection_path(@element, inspection)
      show_more = "<a href='#' id='show-all-periodics' data-element-id=#{@element.id}>Show all periodic inspections</a>"
      ("<li>#{link}</li>" + show_more).html_safe
    else
      "This element has never recieved a periodic inspection"
    end
  end
end
