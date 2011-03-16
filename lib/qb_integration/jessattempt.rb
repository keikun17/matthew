require 'net/http'
require 'net/https'
require 'uri'
require 'rexml/document'

class Quickbooks
  BASE_URI = "https://apps.quickbooks.com/j/AppGateway"
  
  SESS_REQ = "<?xml version=\"1.0\"?><!DOCTYPE QBXML PUBLIC '-//INTUIT//DTD QBXML QBO 6.0//EN' 'http://apps.quickbooks.com/dtds/qbxmlops60.dtd'><QBXML><SignonMsgsRq><SignonDesktopRq><ClientDateTime>2007-03-14T11:27:47</ClientDateTime><ApplicationLogin>devex-prod-desktop</ApplicationLogin><ConnectionTicket>TGT-86-c$emuIaGRaxnCIpqZOmH_g</ConnectionTicket><Language>English</Language><AppID>87618680</AppID><AppVer>1.0</AppVer></SignonDesktopRq></SignonMsgsRq></QBXML>"
  
  TEST_ADD_CUSTOMER_QUERY = %{
    <QBXMLMsgsRq onError="stopOnError">
      <CustomerAddRq>
        <CustomerAdd>
          <Name>Nico Suria</Name>
          <BillAddress>
            <Addr1 />
          </BillAddress>
          <Email>nico.suria@devex.com</Email>
        </CustomerAdd>
      </CustomerAddRq>
    </QBXMLMsgsRq>
  }
  
  TEST_ADD_SALES_RECEIPT_QUERY = %{
    <QBXMLMsgsRq onError="stopOnError">
      <SalesReceiptAddRq>
        <SalesReceiptAdd>
          <CustomerRef><FullName>Raj Kumar</FullName></CustomerRef>
          <TxnDate>2009-02-01</TxnDate>
          <RefNumber>VLEE3D03A835</RefNumber>
          <PaymentMethodRef>
            <FullName>Verisign</FullName>
          </PaymentMethodRef>
          <Memo>IPM (monthly)</Memo>
          <DepositToAccountRef>
            <FullName>Citibank</FullName>
          </DepositToAccountRef>
          <SalesReceiptLineAdd>
            <ItemRef>
              <FullName>Membership Income:IPM (monthly)</FullName>
            </ItemRef>
            <Desc />
          </SalesReceiptLineAdd>
        </SalesReceiptAdd>
      </SalesReceiptAddRq>
    </QBXMLMsgsRq>
  }
  
  def self.add_new_sales_receipt(name, date, reference_number, service_type, desc)
    
		query = %{
      <QBXMLMsgsRq onError="stopOnError">
        <SalesReceiptAddRq>
          <SalesReceiptAdd>
            <CustomerRef><FullName>#{name}</FullName></CustomerRef>
            <TxnDate>#{date.strftime('%Y-%m-%d')}</TxnDate>
            <RefNumber>#{reference_number}</RefNumber>
            <PaymentMethodRef>
              <FullName>Verisign</FullName>
            </PaymentMethodRef>
            <Memo>#{service_type}</Memo>
            <DepositToAccountRef>
              <FullName>Citibank</FullName>
            </DepositToAccountRef>
            <SalesReceiptLineAdd>
              <ItemRef>
                <FullName>Membership Income:#{service_type}</FullName>
              </ItemRef>
              <Desc>#{desc}</Desc>
            </SalesReceiptLineAdd>
          </SalesReceiptAdd>
        </SalesReceiptAddRq>
      </QBXMLMsgsRq>
    }
    response_body = self.post(query)  
    doc = REXML::Document.new(response_body)
    status_code = doc.elements["QBXML/QBXMLMsgsRs/SalesReceiptAddRs"].attributes["statusCode"]
    if status_code == "0"
      true
    else
      false
    end
  end
  
  def self.does_sales_receipt_exists?(reference_number)
    query = %{
      <QBXMLMsgsRq onError="continueOnError">
        <SalesReceiptQueryRq>
          <RefNumber>#{reference_number}</RefNumber>
        </SalesReceiptQueryRq>
      </QBXMLMsgsRq>
    }
    response_body = self.post(query)  
    doc = REXML::Document.new(response_body)
    status_code = doc.elements["QBXML/QBXMLMsgsRs/SalesReceiptQueryRs"].attributes["statusCode"]
    if status_code == "0"
      true
    else
      false
    end
  end
  
  def self.add_new_customer(name, address, email)
		query = %{
            <QBXMLMsgsRq onError="stopOnError">
              <CustomerAddRq>
                <CustomerAdd>
                  <Name>#{name}</Name>
                  <BillAddress>
                    <Addr1>#{address}</Addr1>
                  </BillAddress>
                  <Email>#{email}</Email>
                </CustomerAdd>
              </CustomerAddRq>
            </QBXMLMsgsRq>
          }
    response_body = self.post(query)  
    doc = REXML::Document.new(response_body)
    status_code = doc.elements["QBXML/QBXMLMsgsRs/CustomerAddRs"].attributes["statusCode"]
    if status_code == "0"
      true
    else
      false
    end
  end
  
  def self.post(qb_query)
    
    sess_req_template = self.get_ticket
    template_query = %{<?xml version="1.0" ?>
              <!DOCTYPE QBXML PUBLIC '-//INTUIT//DTD QBXML QBO 6.0//EN' 'http://apps.quickbooks.com/dtds/qbxmlops60.dtd'>
              <QBXML>
                #{sess_req_template}
                #{qb_query}
              </QBXML>}
              
    response_body = self.process_request(template_query)
    puts "response_body: #{response_body}"
    return response_body
  end
  
  def self.process_request(query)
    puts "query: #{query}"
    uri = URI.parse(BASE_URI)
    response = Net::HTTP.start(uri.host) {|http|
      http.post('/j/AppGateway', query, 'Content-Type' => 'application/x-qbxml')
    }
    response.body
  end
    
  def self.get_ticket
    sess_rq_body = self.process_request(SESS_REQ)
    doc = REXML::Document.new(sess_rq_body)
    session_ticket = doc.root.elements["SignonMsgsRs/SignonDesktopRs/SessionTicket"].text.to_s
    sess_req_template = %{
      <SignonMsgsRq>
        <SignonTicketRq>
          <ClientDateTime>#{DateTime.now.strftime('%Y-%m-%dT%H:%M:%S')}</ClientDateTime>
          <SessionTicket>#{session_ticket}</SessionTicket>
          <Language>English</Language>
          <AppID>87618680</AppID>
          <AppVer>1.0</AppVer>
        </SignonTicketRq>
      </SignonMsgsRq>
    }
    sess_req_template
  end
end
