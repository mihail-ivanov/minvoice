class CreateInvoiceRows < ActiveRecord::Migration
  def change
    create_table :invoice_rows do |t|
      t.references :invoice, index: true, foreign_key: true
      t.string :title
      t.decimal :amount
      t.decimal :amount_in_currency
      t.integer :quantity
      t.decimal :amount_per_hour
    end
  end
end
