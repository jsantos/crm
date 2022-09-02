require "test_helper"

class Api::V1::Companies::GroupsControllerTest < ActionDispatch::IntegrationTest
  describe 'GET :index' do
    let(:company) { companies(:globalsign) }

    it 'returns all existing groups from the target company' do
      get api_v1_company_groups_url(company.id)
      _(JSON.parse(response.body)).wont_be :empty?
      assert_response :success
    end
  end

  describe 'POST :create' do
    let(:company) { companies(:globalsign) }
    let(:params) { { group: { name: 'C-Levels' } } }

    subject { post api_v1_company_groups_url(company.id), params: params }

    it 'creates a new group in the company' do
      assert_difference('company.groups.count', 1) do
        subject
      end
    end

    it 'does not create a group if the parameters are not valid' do
      params[:group][:name] = nil

      subject

      _(JSON.parse(response.body)['errors']).must_include 'name'
      _(response.status).must_equal 422
    end
  end

  describe 'DELETE :destroy' do
    let(:company) { companies(:globalsign) }
    let(:group) { groups(:human_resources) }

    subject {
      delete api_v1_company_group_url(company_id: company.id, id: group.id)
    }

    it 'deletes the group' do
      assert_difference('company.groups.count', -1) do
        subject
      end
    end

    it 'un-assigns users from this group' do
      user = users(:john_doe)
      # Add John Doe to this group
      group.users << user

      subject

      _(user.group_ids).wont_include group.id
    end

    it 'returns a 404 code if the group does not exist' do
      delete api_v1_company_group_url(company_id: company.id, id: -1)
      _(response.status).must_equal 404
    end
  end
end
