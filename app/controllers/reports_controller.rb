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
  
  def export
    @date_from = db_date(params[:date_from])
    @date_to = db_date(params[:date_to])
    case params[:list_of]
    when 'invoice'
      @transactions = Transaction.invoices.page(params[:page]).where(:created_at => @date_from..@date_to).includes([:paypal_account => :devex_account])
      @total = Transaction.invoices.where(:created_at => @date_from..@date_to).sum(:amount)
    when 'credit'
      @transactions = Transaction.credits.page(params[:page]).where(:created_at => @date_from..@date_to).includes([:paypal_account => :devex_account])
      @total = Transaction.credits.where(:created_at => @date_from..@date_to).sum(:amount)
    else        
      @transactions = Transaction.page(params[:page])
      @total = Transaction.sum(:amount)
    end
    
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    sheet1.name = "#{params[:list_of]} : #{params[:date_from]} to #{params[:date_to]}"

    sheet1.row(0).concat ['Paypal Transaction ID', 'Paypal Email', 'Devex Username', 'Product', 'Amount', 'Date']
    @transactions.each do |transaction|
      sheet1.row(@transactions.index_of(transaction) + 1).concat [transaction.transaction_reference, 
        transaction.payer_email,
        transaction.devex_user_full_name,
        transaction.product,
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
