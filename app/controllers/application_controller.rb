class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate

  protected

  helper_method :current_user, :user_signed_in?
  def current_user
    Developer.find_by_id(session[:user_id])
  end

  def user_signed_in?
    current_user
  end

  # http://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Basic.html
  def authenticate
    return unless Developer.exists?

    if user = authenticate_with_http_basic { |u, p| Developer.find_by(email: u).try(:authenticate, p) }
      session[:user_id] =  user.id
    else
      request_http_basic_authentication
    end
  end

end
