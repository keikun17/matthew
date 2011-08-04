class User < ActiveRecord::Base
  establish_connection DFA_DB
  
  def consultant
    Consultant.find_by_dfa_id(self.id)
  end
end
