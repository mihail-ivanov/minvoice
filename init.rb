Redmine::Plugin.register :minvoice do
  name 'Minvoice plugin for Redmine'
  author 'Mihail Ivanov'
  description 'This is an Invoice plugin for Redmine'
  version '0.0.1'
  url 'http://github.com/mihail-ivanov/minvoice'
  author_url 'http://muplextech.com'

  project_module :minvoice do
    permission :list_companies, companies: :index
    permission :create_companies, companies: :create
    permission :edit_companies, companies: :edit
    permission :update_companies, companies: :update
    permission :destroy_companies, companies: :destroy

    permission :list_invoice_templates, invoice_templates: :index
    permission :new_invoice_templates, invoice_templates: :new
    permission :create_invoice_templates, invoice_templates: :create
    permission :edit_invoice_templates, invoice_templates: :edit
    permission :update_invoice_templates, invoice_templates: :update
    permission :destroy_invoice_templates, invoice_templates: :destroy

    permission :list_invoices, invoices: :index
    permission :new_invoices, invoices: :new
    permission :create_invoices, invoices: :create
    permission :edit_invoices, invoices: :edit
    permission :update_invoices, invoices: :update
    permission :export_invoices, invoices: :export
    permission :destroy_invoices, invoices: :destroy
  end

  menu :project_menu, :minvoice, { :controller => 'invoices', :action => 'index' }, :caption => 'Minvoice', :after => :issues, :param => :project_id
end
