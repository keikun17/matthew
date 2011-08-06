class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_admin!
  
  private
  
  def db_date(date)
    date.to_date.to_s(:db)
  end
 
end
