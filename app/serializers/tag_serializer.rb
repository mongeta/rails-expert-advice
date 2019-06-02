# == Schema Information
#
# Table name: tags
#
#  id   :bigint           not null, primary key
#  name :string
#

class TagSerializer < ActiveModel::Serializer
  attributes :name
end
