# == Schema Information
#
# Table name: companies
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_companies_on_code  (code) UNIQUE
#
class Company < ApplicationRecord
  MAX_USERS = 10

  has_many :groups, dependent: :destroy
  has_many :users, dependent: :destroy

  validates :code, presence: true,
                   uniqueness: true,
                   length: { maximum: 50 },
                   format: {
                     with: /\A[a-zA-Z0-9-]+\z/,
                     message: 'has an invalid format'
                   }

  # One company cannot have more than 10 users
  def accepting_users?
    users.count < Company::MAX_USERS
  end
end
