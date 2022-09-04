class Api::V1::Companies::Groups::UsersController < Api::V1::BaseController
  before_action :set_company, :set_group

  def create
    @user = @company.users.find(user_params[:id])
    @group.users << @user
    head :ok
  end

  def destroy
    @user = @company.users.find(params[:id])
    @group.users.delete(@user)
    head :ok
  end

  private

  def set_company
    @company = Company.includes(:groups).find(params[:company_id])
  end

  def set_group
    @group = @company.groups.find(params[:group_id])
  end

  def user_params
    params.require(:user).permit(:id)
  end
end
