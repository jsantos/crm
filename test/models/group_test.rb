require "test_helper"

class GroupTest < ActiveSupport::TestCase
  let(:company) { companies(:globalsign) }
  let(:group) { groups(:human_resources) }
  let(:other_company_group) { groups(:executive_board) }

  it 'is valid with a name' do
    _(group).must_be :valid?
  end

  it "is valid if the name is the same as other company's group name" do
    new_group = Group.new(company:, name: other_company_group.name)
    _(new_group).must_be :valid?
  end

  it 'is invalid without a name' do
    group.name = nil
    _(group).wont_be :valid?
  end

  it 'is invalid with a name longer than 100 characters' do
    very_long_group = Group.new(
      company:,
      name: SecureRandom.alphanumeric(101)
    )
    _(very_long_group).wont_be :valid?
  end

  it 'is invalid if the name is not unique within the company' do
    new_group = Group.new(company: group.company, name: group.name)
    _(new_group).wont_be :valid?
  end
end
