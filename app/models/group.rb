# == Schema Information
#
# Table name: groups
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :bigint           not null
#
# Indexes
#
#  index_groups_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Group < ApplicationRecord
  belongs_to :company
  validates :name, presence: true,
                   uniqueness: { scope: :company },
                   length: { maximum: 100 }
end
