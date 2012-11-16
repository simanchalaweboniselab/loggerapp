class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_admin, :current_admin_session

  def should_be_login
    redirect_to "/login" unless current_admin
  end


  private

  def current_admin_session
    return @current_admin_session if defined?(@current_admin_session)
    @current_admin_session = AdminSession.find
  end

  def current_admin
    return @current_admin if defined?(@current_admin)
    @current_admin = current_admin_session && current_admin_session.record
  end

end
