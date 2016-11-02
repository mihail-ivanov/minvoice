class InvoicesController < ApplicationController
  unloadable


  before_filter :find_project, :authorize
  before_filter :load_and_validate_invoice, only: [:edit, :update, :export, :destroy]

  def index
    @invoices = Invoice.where(project_id: @project.id).order(:number)
  end

  def new
    @invoice = Invoice.new
    @invoice.issue_date = Date.today
    @invoice.invoice_rows.build

    @companies = Company.where(project_id: @project.id).order(:name)
    @invoice_templates = InvoiceTemplate.where(project_id: @project.id).order(:name)
  end

  def create
    contractor_company = Company.find(params[:invoice][:contractor_id])
    recipient_company = Company.find(params[:invoice][:recipient_id])

    invoice = Invoice.new(invoice_params)
    invoice.project_id = @project.id
    invoice.set_contractor(contractor_company)
    invoice.set_recipient(recipient_company)
    invoice.save

    redirect_to invoices_url(project_id: @project.identifier)
  end

  def edit
    @companies = Company.where(project_id: @project.id).order(:name)
    @invoice_templates = InvoiceTemplate.where(project_id: @project.id).order(:name)
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to invoices_url(project_id: @project.identifier)
    else
      render 'edit'
    end
  end

  def export
    respond_to do |format|
      format.pdf do
        pdf = WickedPdf.new.pdf_from_string(@invoice.render_template)
        filename = "invoice_#{@invoice.number}.pdf"
        send_data pdf, filename: filename, type: 'application/pdf'
      end
    end
  end

  def destroy
    @invoice.destroy!

    redirect_to invoices_url(project_id: @project.identifier)
  end

  private

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:project_id])
  end

  def load_and_validate_invoice
    @invoice = Invoice.find(params[:id])

    if @invoice.project_id != @project.id
      redirect_to invoices_url(project_id: @project.identifier)
    end
  end

  def invoice_params
    params.require(:invoice).permit(
      :number, :issue_date, :total_amount, :total_amount_words,
      :total_net_amount, :total_net_amount_words,
      :total_vat_amount, :total_vat_amount_words, :currency,
      :additional_currency, :description, :invoice_template_id,
      invoice_rows_attributes: [:title, :amount, :amount_in_currency, :quantity, :amount_per_hour]
    )
  end
end
