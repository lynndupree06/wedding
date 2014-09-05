class AdminController < ActionController::Base
  require 'csv'
  require 'rails/all'

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  http_basic_authenticate_with name: 'jfk', password: '*$t@r8@r'
end