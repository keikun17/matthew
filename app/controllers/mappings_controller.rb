class MappingsController < ApplicationController
  def index
    @devex_users = DevexUser.find(:all)
  end
  
  def do_map
    @paypal_account = PaypalAccount.find(params[:paypal_account_id])
    @consultant = Consultant.find(params[:consultant_id])
    if @devex_user.nil?
      @devex_user = DevexUser.new(:account_id => @consultant.id,
        :username => @consultant.user.username,
        :account_type => "Consultant",
        :first_name => @consultant.first_name,
        :last_name => @consultant.last_name)
      if @devex_user.save
        if @paypal_account.update_attributes(:devex_user_id => @devex_user.id)
          flash[:notice] = "Paypal User #{@paypal_account.email} has been succesfully mapped to Devex User #{@devex_user.username}"
          redirect_to '/mappincgs'
        end
      end
    else
      @paypal_account.devex_user_id = @devex_user.id
      if @paypal_account.save
        if @paypal_account.update_attributes(:devex_user_id => @devex_user.id)
          flash[:notice] = "#{@paypal_account.email} has been succesfully mapped to #{@devex_user.username}"
          redirect_to '/mappings'
        end
      end
    end
  end
  
end
