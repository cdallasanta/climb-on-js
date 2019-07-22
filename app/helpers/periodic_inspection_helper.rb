module PeriodicInspectionHelper
  # comments with content are put in an uneditable fashion, and the
  # new empty comments area textfields for adding comments
  def print_comments(ff)
    if ff.object.content != nil
      "<strong>#{ff.object.user.fullname}:</strong> #{ff.object.content}<br>".html_safe
    end
  end
end
