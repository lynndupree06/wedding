class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  http_basic_authenticate_with name: 'jfk', password: '*$t@r8@r'

#   unless Rails.application.config.consider_all_requests_local
# 	  rescue_from Exception,
# 	              :with => :render_error
# 	  rescue_from ActiveRecord::RecordNotFound,
# 	              :with => :render_not_found
# 	  rescue_from ActionController::RoutingError,
# 	              :with => :render_not_found
# 	  rescue_from ActionController::UnknownController,
# 	              :with => :render_not_found
# 	  rescue_from ActionController::UnknownAction,
# 	              :with => :render_not_found
# 	end

#   protected

#   def render_not_found(exception)
#   render :template => "/errors/404.html.erb",
#          :layout => 'errors.html.erb'
# end
 
# def render_error(exception)
#   ExceptionNotifier::Notifier
#     .exception_notification(request.env, exception)
#     .deliver
#   render :template => "/errors/500.html.erb",
#          :layout => 'errors.html.erb'
# end
end
