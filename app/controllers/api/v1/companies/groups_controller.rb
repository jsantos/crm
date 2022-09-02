class Api::V1::Companies::GroupsController < Api::V1::BaseController
  before_action :set_company

  def index
    @groups = @company.groups
    render :index, status: :ok
  end

  def create
    @group = @company.groups.create(group_params)
    if @group.persisted?
      render :show, status: :ok
    else
      render json: { errors: @group.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @group = @company.groups.find(params[:id])
    # When a group is destroyed, the Has and Belongs to Many relation will
    # automatically remove the records connecting this group to the user table.
    @group.destroy
    head :no_content
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

  def set_company
    # Eager load groups and users to avoid N+1 queries
    @company = Company.includes(groups: [:users]).find(params[:company_id])
  end
end
