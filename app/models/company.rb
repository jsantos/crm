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
  validates :code, presence: true,
                   uniqueness: true,
                   length: { maximum: 50 },
                   format: {
                     with: /\A[a-zA-Z0-9-]+\z/,
                     message: 'has an invalid format'
                   }
end
