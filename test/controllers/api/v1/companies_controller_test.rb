require "test_helper"

class Api::V1::CompaniesControllerTest < ActionDispatch::IntegrationTest
  describe 'GET :index' do
    it 'returns all existing companies' do
      get api_v1_companies_url
      _(JSON.parse(response.body)).wont_be :empty?
      assert_response :success
    end
  end

  describe 'POST :create' do
    let(:company) { companies(:globalsign) }
    let(:params) { { company: { code: 'Acme' } } }

    subject { post api_v1_companies_url, params: params }

    it 'creates a new company' do
      assert_difference('Company.count', 1) do
        subject
      end
    end

    it 'does not create a company with an invalid code' do
      params[:company][:code] = nil
      subject
      _(JSON.parse(response.body)['errors']).must_include 'code'
      _(response.status).must_equal 422
    end
  end

  describe 'DELETE :destroy' do
    let(:company) { companies(:e_corp) }

    subject { delete api_v1_company_url(company.id) }

    it 'deletes the company' do
      assert_difference('Company.count', -1) do
        subject
      end
    end

    it 'returns a 404 code if the company does not exist' do
      delete api_v1_company_url(-1)
      _(response.status).must_equal 404
    end

    # Just to test the Api::V1::BaseController method to handle exceptions
    it 'returns a 500 code if there was any exception raised' do
      Company.any_instance.stubs(:destroy).raises(Exception, 'Oh no!')
      subject
      _(response.status).must_equal 500
    end
  end
end
