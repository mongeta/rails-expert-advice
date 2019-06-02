# == Schema Information
#
# Table name: tags
#
#  id   :bigint           not null, primary key
#  name :string
#

class Tag < ApplicationRecord
  has_many :posts_tags
  has_many :posts, through: :posts_tags
end
