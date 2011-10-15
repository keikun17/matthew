class Company < ActiveRecord::Base
  establish_connection Rails::Application.config.devex_db
  
  def creator
    Consultant.find self.created_by
  end
  
end
