require "test_helper"

class Api::V1::Companies::Groups::UsersControllerTest < ActionDispatch::IntegrationTest
  describe 'POST :create' do
    let(:company) { companies(:globalsign) }
    let(:group) { groups(:engineering) }
    let(:user) {
      company.users.create(
        first_name: 'Jorge',
        last_name: 'Santos',
        email: 'contact@email.com',
        age: 35
      )
    }
    let(:params) { { user: { id: user.id } } }

    subject {
      post api_v1_company_group_users_url(
        company_id: company.id,
        group_id: group.id
      ), params: params
    }

    it 'adds a user to the target group' do
      assert_difference('group.users.count', 1) do
        subject
      end
    end
  end

  describe 'DELETE :destroy' do
    let(:company) { companies(:globalsign) }
    let(:group) { groups(:human_resources) }
    let(:user) { users(:john_doe) }

    before {
      # Add John Doe to the Human Resources group
      group.users << user
    }

    subject {
      delete api_v1_company_group_user_url(
        company_id: company.id,
        group_id: group.id,
        id: user.id
      )
    }

    it 'removes a user from the group' do
      assert_difference('group.reload.users.count', -1) do
        subject
      end
    end
  end
end
