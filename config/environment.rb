# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Matthew::Application.initialize!

# PAYPAL IPN configuration
unless ::Rails.env == 'production'
  PAYPAL_ACCOUNT = 'keikun17@gmail.com'
  PAYPAL_URL = 'https://sandbox.paypal.com/cgi-bin/webscr'
else
  PAYPAL_ACCOUNT = 'keikun17@gmail.com'
  PAYPAL_URL = 'https://paypal.com/cgi-bin/webscr'
end