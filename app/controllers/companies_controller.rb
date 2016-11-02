class CompaniesController < ApplicationController
  unloadable


  before_filter :find_project, :authorize
  before_filter :load_and_validate_company, only: [:edit, :update, :destroy]

  def index
    @company = Company.new
    @companies = Company.where(project_id: @project.id).order(:name)
  end

  def create
    company = Company.new(company_params)
    company.project_id = @project.id
    company.save

    redirect_to companies_url(project_id: @project.identifier)
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to companies_url(project_id: @project.identifier)
    else
      render 'edit'
    end
  end

  def destroy
    @company.destroy!

    redirect_to companies_url(project_id: @project.identifier)
  end

  private

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:project_id])
  end

  def load_and_validate_company
    @company = Company.find(params[:id])

    if @company.project_id != @project.id
      redirect_to companies_url(project_id: @project.identifier)
    end
  end

  def company_params
    params.require(:company).permit(
      :name, :address, :director_name, :identifier,
      :vat_number, :bank_name, :bank_bic, :bank_iban
    )
  end
end
