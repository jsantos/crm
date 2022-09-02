require "test_helper"

class UserTest < ActiveSupport::TestCase
  let(:user) { users(:john_doe) }
  let(:company) { companies(:globalsign) }
  let(:group) { groups(:human_resources) }

  it 'is invalid without first_name' do
    user.first_name = nil
    _(user).wont_be :valid?
  end

  it 'is invalid with a first name over 50 characters' do
    user.first_name = SecureRandom.alphanumeric(51)
    _(user).wont_be :valid?
  end

  it 'is invalid without last_name' do
    user.last_name = nil
    _(user).wont_be :valid?
  end

  it 'is invalid with a last name over 50 characters' do
    user.last_name = SecureRandom.alphanumeric(51)
    _(user).wont_be :valid?
  end

  it 'is invalid without email' do
    user.email = nil
    _(user).wont_be :valid?
  end

  it 'is invalid with a malformed email address' do
    user.email = 'john.doe.com'
    _(user).wont_be :valid?
  end

  it 'is invalid with an existing email address from the same company' do
    other_user = users(:jane_doe)
    other_user.company = company # Jane changed jobs to John's company
    other_user.email = user.email # John Doe's email address
    _(other_user).wont_be :valid?
  end

  it 'is valid if the email is also used on another company' do
    other_user = users(:jane_doe)
    other_user.email = user.email # John Doe's email address
    _(other_user).must_be :valid?
  end

  it 'is invalid without age' do
    user.age = nil
    _(user).wont_be :valid?
  end

  it 'is invalid with a non-numeric age' do
    user.age = 'Eighteen'
    _(user).wont_be :valid?
  end

  it 'is invalid with an age under 18' do
    user.age = 17
    _(user).wont_be :valid?
  end
end
