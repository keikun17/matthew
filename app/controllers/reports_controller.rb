class ReportsController < ApplicationController
  def index

    if params[:product] and params[:date_from] and params[:date_to]
      @product = Product.find params[:product]
      date_from = Date.parse(params[:date_from].to_a.sort.collect{|c| c[1]}.join("-") )
      date_to = Date.parse(params[:date_to].to_a.sort.collect{|c| c[1]}.join("-") )

      @transactions = Transaction.find(:all,
        :conditions => ["product = ? and created_at between ? and ? and classification = ?", 
          @product.paypal_product_code,
          date_from.to_s(:db),
          date_to.to_s(:fb),
          params[:list_of]])
    else        
      @transactions = Transaction.invoices.all
    end
  end
end
