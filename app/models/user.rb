class User < ActiveRecord::Base
  establish_connection Rails::Application.config.dfa_db
  
  def consultant
    Consultant.find_by_dfa_id(self.id)
  end
end
