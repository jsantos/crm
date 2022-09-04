require "test_helper"

class Api::V1::Companies::UsersControllerTest < ActionDispatch::IntegrationTest
  describe 'POST :create' do
    let(:company) { companies(:globalsign) }
    let(:user) { users(:john_doe) }

    describe 'with valid user details' do
      let(:params) {
        {
          user: {
            first_name: 'Joan',
            last_name: 'Doe',
            email: 'joan@doe.com',
            age: 25
          }
        }
      }
      subject { post api_v1_company_users_url(company.id), params: params }

      it 'sucessfully creates a user on the target company' do
        assert_difference('company.users.count', 1) do
          subject
        end
      end

      it 'does not create a user if the company already has Company::MAX_USERS users' do
        # Mocking this method here to avoid slowing the test suite
        # by creating Company::MAX_USERS records
        Company.any_instance.stubs(:accepting_users?).returns(false)

        subject

        _(response.status).must_equal 400
      end
    end

    describe 'with invalid user details' do
      let(:params) {
        {
          user: {
            first_name: 'Joan',
            last_name: 'Doe',
            email: 'joan@doe.com',
            age: 25
          }
        }
      }

      subject { post api_v1_company_users_url(company.id), params: params }

      it 'returns a 400 HTTP code when the user age is lower than 18' do
        params[:user][:age] = 17
        subject
        _(response.status).must_equal 400
      end

      it 'returns a 422 HTTP code when other errors occur' do
        params[:user][:email] = user.email # John Doe's email
        subject
        _(JSON.parse(response.body)['errors']).must_include 'email'
        _(response.status).must_equal 422 # unprocessable entity
      end
    end
  end
end
