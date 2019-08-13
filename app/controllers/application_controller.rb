class ApplicationController < ActionController::Base
  #Make devise model accept other params than
  #email password and password_confirmation

  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit
  protect_from_forgery

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password,
    :password_confirmation, :first_name, :last_name, :phone, :organization_id])
  end

  def after_sign_in_path_for(resource)

		if resource.class == User
		stored_location_for(resource) || welcome_index_path
		else
		stored_location_for(resource) || welcome_rider_path
		end

	end

	def after_sign_out_path_for(resource)
		root_path
	end

end
