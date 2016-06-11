class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :landing_redirect

  def after_sign_in_path_for(resource)
    if session[:join_meal_id]
        path = new_meal_meal_share_path(session[:join_meal_id])
        session[:join_meal_id] = nil
        return path
    else
      return request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    end
  end

  protected

  def landing_redirect
    if request.url != root_url
      redirect_to root_url
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:name, :bio]
  end
end
