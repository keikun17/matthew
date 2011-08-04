class ReportsController < ApplicationController
  def index
    @date_from = params[:date_from] || 1.month.ago
    @date_to = params[:date_to] || 1.days.from_now
    if params[:product] and params[:date_from] and params[:date_to]
      @product = Product.find params[:product]
      @date_from = params[:date_from] #Date.parse(params[:date_from].to_a.sort.collect{|c| c[1]}.join("-") )
      @date_to = params[:date_to] #Date.parse(params[:date_to].to_a.sort.collect{|c| c[1]}.join("-") )
      case params[:list_of]
      when 'invoice'
        @transactions = Transaction.invoices.find(:all,
          :conditions => ["product = ? and created_at between ? and ?", 
            @product.paypal_product_code,
            @date_from.to_date.to_s(:db),
            @date_to.to_date.to_s(:db)])
      when 'credit'
         @transactions = Transaction.credits.find(:all,
           :conditions => ["product = ? and created_at between ? and ?", 
            @product.paypal_product_code,
            @date_from.to_date.to_s(:db),
            @date_to.to_date.to_s(:db)])
      end
    else        
      @transactions = Transaction.paginate(:all, :page => params[:page], :per_page => params[:per_page] )
    end
  end
end
