class UsersController < ApplicationController

  def find_users
    session[:query] = params[:query].strip if params[:query]
    minimum_query_length = 3
    if session[:query] and session[:query].length > minimum_query_length and request.xhr?
      @users = User.find(:all, :conditions => ["LOWER(username) LIKE ?", "%#{session[:query].downcase}%"], :order => "username ASC")
      render :partial => "users/search_results", :layout => false, :locals => {:search_results => @users} 
    else
      render :partial => "users/query_too_short", :layout => false
    end    
  end
  
end