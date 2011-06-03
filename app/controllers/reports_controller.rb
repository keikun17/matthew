class ReportsController < ApplicationController
  def index
    @transactions = Transaction.all
  end
end
