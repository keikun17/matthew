class Company < ActiveRecord::Base
  establish_connection Rails::Application.config.devex_db
end
