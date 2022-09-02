class Api::V1::CompaniesController < Api::V1::BaseController
  def index
    @companies = Company.all
    render :index, status: :ok
  end

  def create
    @company = Company.create(company_params)
    if @company.persisted?
      render :show, status: :ok
    else
      render json: {
        errors: @company.errors
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    head :no_content
  end

  private

  def company_params
    params.require(:company).permit(:code)
  end
end
