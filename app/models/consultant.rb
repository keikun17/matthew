class Consultant < ActiveRecord::Base
  establish_connection DEVEX_DB
  def user
    User.find_by_id(self.dfa_id)
  end
end
