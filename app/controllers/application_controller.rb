class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  #
  before_action :configure_permitted_parameters, if: :devise_controller?


  protected
  #Allows users to sign in using their email or username. Rails4 devise methods.
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username, :email, :password, :password_confirmation)
    end

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:username, :email, :password, :password_confirmation, :current_password)
    end
  end
end
