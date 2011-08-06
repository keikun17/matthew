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
        @transactions = Transaction.invoices.page(params[:page]).where(:product => @product.paypal_product_code, :created_at => db_date(@date_from)..db_date(@date_to))
        @total = Transaction.invoices.where(:product => @product.paypal_product_code, :created_at => db_date(@date_from)..db_date(@date_to)).sum(:amount)
      when 'credit'
        @transactions = Transaction.credits.page(params[:page]).where(:product => @product.paypal_product_code, :created_at => db_date(@date_from)..db_date(@date_to))
        @total = Transaction.credits.where(:product => @product.paypal_product_code, :created_at => db_date(@date_from)..db_date(@date_to)).sum(:amount)
      end
    else        
      @transactions = Transaction.page(params[:page])
      @total = Transaction.sum(:amount)
    end
  end
end
