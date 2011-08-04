# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Matthew::Application.initialize!

# PAYPAL IPN configuration
# unless ::Rails.env == 'production'
#   PAYPAL_ACCOUNT = 'kami_1258106091_biz@devex.com'
#   PAYPAL_URL = 'https://sandbox.paypal.com/cgi-bin/webscr'
# else
#   PAYPAL_ACCOUNT = 'kami_1258106091_biz@devex.com'
#   PAYPAL_URL = 'https://paypal.com/cgi-bin/webscr'
# end

unless ::Rails.env == 'production'
  PAYPAL_ACCOUNT = 'seller@example.com'
  ActiveMerchant::Billing::Base.mode = :test 
else
  PAYPAL_ACCOUNT = 'paypalaccount@example.com'
end

QB_APP_LOGIN = "matthew.matthew.devex.com"
QB_CONNECTION_TICKET = "TGT-63-k9LFQUnw8AkcYiSNKHus_Q"
QB_APP_ID = "209654516"
