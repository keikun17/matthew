require 'rubygems'
require 'httparty'

class Qboe
  include HTTParty
  base_uri 'https://apps.quickbooks.com/j/AppGateway'
  format :xml
  headers 'Content-Type' => 'application/x-qbxml' 

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
  
  def self.create_invoice(customer_name,items)
      today = Time.now.strftime("%Y-%m-%d")
      customer_id = find_customer_id(customer_name)
      full_name = customer_name
      session = self.getSession
      xml_to_send = ERB.new(get_file_as_string("lib/qb_integration/invoice.erb")).result(binding) 
      result = post('/', :body => xml_to_send )
      puts "result : " + result.inspect
      Rails.logger.info result
      result["QBXML"]["QBXMLMsgsRs"]["InvoiceAddRs"]["InvoiceRet"]
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
