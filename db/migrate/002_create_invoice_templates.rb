class CreateInvoiceTemplates < ActiveRecord::Migration
  def change
    create_table :invoice_templates do |t|
      t.integer :project_id
      t.string :name
      t.text :template
    end
  end
end
