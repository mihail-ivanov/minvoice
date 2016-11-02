class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :project_id
      t.string :name
      t.string :address
      t.string :director_name
      t.string :tax_number
      t.string :vat_number
      t.string :bank_name
      t.string :bank_bic
      t.string :bank_iban
    end
  end
end
