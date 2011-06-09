class ReportsController < ApplicationController
  def index
    if params[:product] 
      @product = Product.find params[:product]
      @transactions = @product.transactions
    else        
      @transactions = Transaction.all
    end
  end
end
