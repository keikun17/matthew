class ReportsController < ApplicationController
  def index
    @date_from = params[:date_from] || 1.month.ago
    @date_to = params[:date_to] || 1.days.from_now
    if params[:date_from] and params[:date_to] 
      if params[:product] and params[:product] != "ALL"
         @product = Product.find params[:product]
       end
       @transactions_arel = Transaction.where(:created_at => db_date(@date_from)..db_date(@date_to))

       case params[:list_of]
       when 'invoice'
         @transactions_arel = @transactions_arel.invoices
       when 'credit'
         @transactions_arel = @transactions_arel.credits
       end

       unless @product.nil?
         @transactions_arel = @transactions_arel.where(:product => @product.paypal_product_code)
       end

       @transactions = @transactions_arel.page(params[:page]).includes([{:paypal_account => :devex_user}])
       @total = @transactions_arel.sum(:amount)
    else        
      @transactions = Transaction.page(params[:page])
      @total = Transaction.sum(:amount)
    end
  end
  
  def export
    @date_from = db_date(params[:date_from])
    @date_to = db_date(params[:date_to])
    
    if params[:product] and params[:product] != "ALL"
      @product = Product.find params[:product]
    end
    
    @transactions_arel = Transaction.where(:created_at => @date_from..@date_to)

    case params[:list_of]
    when 'invoice'
      @transactions_arel = @transactions_arel.invoices
    when 'credit'
      @transactions_arel = @transactions_arel.credits
    end

    unless @product.nil?
      @transactions_arel = @transactions_arel.where(:product => @product.paypal_product_code)
    end

    @transactions = @transactions_arel.includes([{:paypal_account => :devex_user}])
    @total = @transactions_arel.sum(:amount)
    
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    sheet1.name = "#{params[:list_of]} : #{params[:date_from]} to #{params[:date_to]}"

    sheet1.row(0).concat ['Paypal Transaction ID', 'Paypal Email', 'Devex Username', 'Product', 'Amount', 'Date']
    @transactions.each do |transaction|
      sheet1.row(@transactions.index(transaction) + 1).concat [transaction.transaction_reference, 
        transaction.payer_email,
        transaction.devex_user_full_name,
        transaction.product,
        transaction.amount.to_s,
        transaction.created_at ]
    end

    format = Spreadsheet::Format.new :color => :blue,
                                     :weight => :bold,
                                     :size => 18

    sheet1.row(0).default_format = format
    bold = Spreadsheet::Format.new :weight => :bold
    6.times do |x| sheet1.row(x + 1).set_format(0, bold) end
    filepath = "#{RAILS_ROOT}/tmp/"
    filename = "test.xls"
    book.write(filepath + filename)
    send_file(filepath + filename)
  end
end
