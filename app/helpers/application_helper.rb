module ApplicationHelper
  def logged_in?
    !!session[:user_id]
  end

  def current_user
    if logged_in?
      User.find(session[:user_id])
    end
  end

  def current_site
    current_user.site
  end

  # adds form errors to the top of the form
  def errors_check(object)
    if object.errors.any?
      render partial: 'application/errors', locals: {object: object}
    end
  end
end
