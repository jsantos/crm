# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  age        :integer          not null
#  email      :string           not null
#  first_name :string           not null
#  last_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :bigint           not null
#
# Indexes
#
#  index_users_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class User < ApplicationRecord
  MIN_AGE = 18

  belongs_to :company
  has_and_belongs_to_many :groups

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true,
                    uniqueness: { scope: :company },
                    format: {
                      with: URI::MailTo::EMAIL_REGEXP,
                      message: 'has an invalid format'
                    }
  validates :age, presence: true,
                  numericality: true,
                  comparison: { greater_than_or_equal_to: MIN_AGE }
end
