class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :project_id
      t.integer :invoice_template_id
      t.integer :number
      t.date :issue_date
      t.decimal :total_amount
      t.string :total_amount_words
      t.decimal :total_vat_amount
      t.string :total_vat_amount_words
      t.string :currency
      t.string :additional_currency
      t.integer :contractor_id
      t.string :contractor_name
      t.string :contractor_address
      t.string :contractor_director_name
      t.string :contractor_tax_number
      t.string :contractor_vat_number
      t.string :contractor_bank_name
      t.string :contractor_bank_bic
      t.string :contractor_bank_iban
      t.integer :recipient_id
      t.string :recipient_name
      t.string :recipient_address
      t.string :recipient_director_name
      t.string :recipient_tax_number
      t.string :recipient_vat_number
      t.string :recipient_bank_name
      t.string :recipient_bank_bic
      t.string :recipient_bank_iban
      t.string :description
    end
  end
end
