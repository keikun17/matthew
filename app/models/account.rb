class Account < ActiveRecord::Base
  establish_connection Rails::Application.config.devex_db

  def owner
    case self.owner_type
    when 'Consultant'
      Consultant.where(:id => self.owner_id)
    when 'Company'
      Company.where(:id => self.owner_id).creator
    end
  end
  
end
