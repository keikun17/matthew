class MappingController < ApplicationController
  def index
    @devex_users = DevexUser.find(:all)
  end
  
  def do_map
    @paypal_account = PaypalAccount.find(params[:paypal_account_id])
    @consultant = Consultant.find(params[:consultant_id])
    @devex_user = DevexUser.find_by_username(@consultant.username)
    if @devex_user.nil?
      @devex_user = DevexUser.new(:account_id => @consultant.id,
        :username => @consultant.username,
        :account_type => "Consultant",
        :first_name => @consultant.first_name,
        :last_name => @consultant.last_name)
      if @devex_user.save
        if @paypal_account.update_attributes(:devex_user_id => @devex_user.id)
          redirect_to '/mapping'
        end
      end
    else
      @paypal_account.devex_user_id = @devex_user.id
      if @paypal_account.save
        redirect_to '/mapping'
      end
    end
  end
  
end
