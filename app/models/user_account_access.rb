# == Schema Information
#
# Table name: user_account_accesses
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  account_id  :bigint
#  access_type :integer          default("owner"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class UserAccountAccess < ApplicationRecord
  belongs_to :user
  belongs_to :account
  enum access_type: { owner: 0, admin: 1, limited: 2 }
end
