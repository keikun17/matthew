class Consultant < ActiveRecord::Base
  establish_connection Rails::Application.config.devex_db
  def user
    User.find_by_id(self.dfa_id)
  end
end
