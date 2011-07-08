require 'rubygems'
require 'httparty'

class Qboe
  include HTTParty
  base_uri 'https://apps.quickbooks.com/j/AppGateway'
  format :xml
  headers 'Content-Type' => 'application/x-qbxml' 
  QB_BATCH_NAME = "INDIVIDUAL PROFESSIONAL MEMBER"
  # APPLICATION_LOGIN = 'your application login'
  # CONNECTION_TICKET = 'your connection ticket'
  # APPLICATION_ID = 'your application id'
  
  def self.find_customer_id(full_name)
      request_id = '123'
      session = getSession
      today = Time.now.strftime("%Y-%m-%d")
      xml_to_send = ERB.new(get_file_as_string("lib/qb_integration/customer.erb")).result(binding) 
      result = post('/', :body => xml_to_send )
      Rails.logger.info result
      result["QBXML"]["QBXMLMsgsRs"]["CustomerQueryRs"]["CustomerRet"]["ListID"]
  end
  
  def self.create_invoice(customer_name, items)
      today = Time.now.strftime("%Y-%m-%d")
      customer_id = find_customer_id(customer_name)            
      full_name = customer_name
      session = self.getSession
      xml_to_send = ERB.new(get_file_as_string("lib/qb_integration/invoice.erb")).result(binding) 
      result = post('/', :body => xml_to_send )
      puts "result : " + result.inspect
      Rails.logger.info result
      params = result["QBXML"]["QBXMLMsgsRs"]["InvoiceAddRs"]["InvoiceRet"]
      Rails.logger.info "---- InvoiceRet ---"
      Rails.logger.info params
      txn_id = params["TxnID"]
      amount = params["Subtotal"]
      create_payment(full_name, txn_id, amount)
  end
  
  def self.create_sales_receipt(customer_name, items, devex_username)
      today = Time.now.strftime("%Y-%m-%d")
      customer_id = find_customer_id(customer_name)            
      full_name = customer_name
      session = self.getSession
      xml_to_send = ERB.new(get_file_as_string("lib/qb_integration/sales_receipt.erb")).result(binding) 
      result = post('/', :body => xml_to_send )
      puts "result : " + result.inspect
      Rails.logger.info result
  end
  
  def self.upload_batch_sales_receipt
      batch_qb_member_name = QB_BATCH_NAME

      # get receipt_lines
      receipt_lines = Transaction.unscoped.find(:all, :select => "distinct product, count(product) as count", :conditions => {:classification => 'invoice', :for_next_bulk_update => true}, :group => "product").map{|x| {:count => x.count, :product => x.product }}
      today = Time.now.strftime("%Y-%m-%d")
      session = self.getSession

      xml_to_send = ERB.new(get_file_as_string("lib/qb_integration/batch_sales_receipt.erb")).result(binding) 
      result = post('/', :body => xml_to_send )
      puts "result : " + result.inspect
      Rails.logger.info result
      
      #Mark as uploaded
      Transaction.invoices.for_next_bulk_update.each do |transaction|
        transaction.update_attribute(:for_next_bulk_update, false)
        transaction.update_attribute(:uploaded_to_qb, true)
      end
  end
  
  # TODO
  def self.upload_batch_credit_memo
    batch_qb_member_name = QB_BATCH_NAME

    # get receipt_lines
    receipt_lines = Transaction.unscoped.find(:all, :select => "distinct product, count(product) as count", :conditions => {:classification => 'credit', :for_next_bulk_update => true}, :group => "product").map{|x| {
      :count => x.count,
      :product => x.product,
      :amount => sprintf("%.2f", Transaction.credits.for_next_bulk_update.sum(:amount, :conditions => {:product => x.product}).abs)
      }}
    today = Time.now.strftime("%Y-%m-%d")
    session = self.getSession

    xml_to_send = ERB.new(get_file_as_string("lib/qb_integration/batch_credit_memo.erb")).result(binding) 
    result = post('/', :body => xml_to_send )
    puts "result : " + result.inspect
    Rails.logger.info result
    
    #Mark as uploaded
    unless result.inspect["QBXML"]["QBXMLMsgsRs"]["CreditMemoAddRs"]["statusSeverity"].eql?("Error")
      Transaction.credits.for_next_bulk_update.each do |transaction|
        transaction.update_attribute(:for_next_bulk_update, false)
        transaction.update_attribute(:uploaded_to_qb, true)
      end
    end
  end  
  
  def self.create_credit(customer_name, amount, items)
    today = Time.now.strftime("%Y-%m-%d")
    amount = [amount].abs
    customer_id = find_customer_id(customer_name)
    full_name = customer_name
    session = self.getSession
    xml_to_send = ERB.new(get_file_as_string("lib/qb_integration/credit.erb")).result(binding) 
    result = post('/', :body => xml_to_send )
    puts "result : " + result.inspect
    Rails.logger.info "-----"
    Rails.logger.info result
  end
  
  def self.create_payment(customer_name, txn_id, amount)
    today = Time.now.strftime("%Y-%m-%d")
    customer_id = find_customer_id(customer_name)
    full_name = customer_name
    session = self.getSession
    xml_to_send = ERB.new(get_file_as_string("lib/qb_integration/payment.erb")).result(binding) 
    result = post('/', :body => xml_to_send )
    puts "result : " + result.inspect
    Rails.logger.info "-----"
    Rails.logger.info result
  end
  
  
  def self.getSession
      today = Time.now.strftime("%Y-%m-%d")
      xml_to_send = ERB.new(get_file_as_string("lib/qb_integration/session.erb")).result(binding) 
      result = post('/', :body => xml_to_send )
      puts "result:" + result.inspect
      Rails.logger.info result
      result["QBXML"]["SignonMsgsRs"]["SignonDesktopRs"]["SessionTicket"]
  end
    
  def self.get_file_as_string(filename)
    data = ''
    f = File.open(filename, "r") 
    f.each_line do |line|
      data += line
    end
    return data
  end
    
end
