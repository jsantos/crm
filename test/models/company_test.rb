require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  let(:company) { companies(:globalsign) }

  it 'is valid with a code' do
    _(company).must_be :valid?
  end

  it 'is invalid without a code' do
    company.code = nil
    _(company).wont_be :valid?
  end

  it 'is invalid if the desired code is already in use' do
    new_company = Company.new(code: company.code)
    _(new_company).wont_be :valid?
  end

  it 'is invalid with a code bigger than 50 characters' do
    very_long_company = Company.new(code: SecureRandom.alphanumeric(51))
    _(very_long_company).wont_be :valid?
  end

  it 'is invalid if the code does not have only alphanumeric chars and dashes' do
    exotic_company = Company.new(code: '©Ømp∏n¥!')
    _(exotic_company).wont_be :valid?
  end
end
