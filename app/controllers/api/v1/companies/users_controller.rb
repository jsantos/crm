class Api::V1::Companies::UsersController < Api::V1::BaseController
  before_action :set_company

  def create
    if !@company.accepting_users?
      error_msg = "#{@company.code} already has #{Company::MAX_USERS} users."
      render json: { errors: [error_msg] }, status: :bad_request # HTTP 400
    else
      @user = @company.users.create(user_params)
      if @user.persisted?
        render :show, status: :ok
      else
        render json: { errors: @user.errors }, status: error_code_for_age_error
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :age
    )
  end

  def set_company
    @company = Company.includes(:users).find(params[:company_id])
  end

  # Custom code to filter this specific error
  def error_code_for_age_error
    if @user.errors[:age] && @user.age < User::MIN_AGE
      :bad_request # HTTP 400
    else # And still process regular errors
      :unprocessable_entity
    end
  end
end
