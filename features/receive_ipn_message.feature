# Feature: Paypal IPN Integration
#   In order to process notifications from Paypal
#   As a site owner
#   I want to be able to process and validate the IPN and record transactions
#   
# Scenario: IPN item array handling
#   Given an incoming IPN for 4 items
#   Then the notification should have 4 items returned
#   And the first item should be "Item 1"
#   And the last item should be "Item 4"
#   
# Scenario: IPN price accuracy
#   Given an incoming IPN for 4 items that cost 10 each
#   # Given an incoming IPN for 4 items
#   Then the notification should have a gross amount of 40
#   
# Scenario: Payment Controller process IPN for cart purchase
#   Given a transaction exists with status: "Unpaid", user_id: "1", transaction_reference: "12345", user_type: "Consultant"
#   When an IPN comes in for that transaction
#   Then a transaction should exist with transaction_reference: "12345", status: "Paid", user_id: "1", user_type: "Consultant"
