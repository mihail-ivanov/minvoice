class InvoiceRow < ActiveRecord::Base
  unloadable

  belongs_to :invoice
end
