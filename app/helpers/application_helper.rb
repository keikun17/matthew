module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this, '#{association}', '#{escape_javascript(fields)}')"))
  end
  
  def transaction_count
    link_to((Transaction.count.to_s + " Transactions"), '#' ,:class => "cool-link-green")
  end
  
  def orphan_paypal_accounts_count
    link_to((PaypalAccount.orphans.count.to_s + " Paypal Accounts"), orphans_paypal_accounts_path,:class => "cool-link-blue")
  end
  
  def uploadable_transactions_count
    link_to(Transaction.uploadable.count.to_s + " Transactions", '#',:class => "cool-link-red") 
  end
  
  def invoices_for_next_batch_update
    link_to(Transaction.invoices.for_next_bulk_update.count.to_s + "Sales Receipts", bulk_upload_sales_receipts_to_quickbooks_path(:classification => "invoice"), :class => "cool-link-red") 
  end
  
  def credit_memos_for_next_batch_update
    link_to(Transaction.credits.for_next_bulk_update.count.to_s + " Credit Memos", bulk_upload_credit_memos_to_quickbooks_path(:classification => "credit"), :class => "cool-link-red") 
  end
  
end