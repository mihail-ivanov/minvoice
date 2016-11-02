class InvoiceTemplatesController < ApplicationController
  unloadable


  before_filter :find_project, :authorize
  before_filter :load_and_validate_invoice_template, only: [:edit, :update, :destroy]

  def index
    @invoice_templates = InvoiceTemplate.where(project_id: @project.id)
  end

  def new
    @invoice_template = InvoiceTemplate.new
  end

  def create
    invoice_template = InvoiceTemplate.new(invoice_template_params)
    invoice_template.project_id = @project.id
    invoice_template.save

    redirect_to invoice_templates_url(project_id: @project.identifier)
  end

  def edit
  end

  def update
    if @invoice_template.update(invoice_template_params)
      redirect_to invoice_templates_url(project_id: @project.identifier)
    else
      render 'edit'
    end
  end

  def destroy
    @invoice_template.destroy!

    redirect_to invoice_templates_url(project_id: @project.identifier)
  end

  private

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:project_id])
  end

  def load_and_validate_invoice_template
    @invoice_template = InvoiceTemplate.find(params[:id])

    if @invoice_template.project_id != @project.id
      redirect_to invoice_templates_url(project_id: @project.identifier)
    end
  end

  def invoice_template_params
    params.require(:invoice_template).permit(:name, :template)
  end

end
