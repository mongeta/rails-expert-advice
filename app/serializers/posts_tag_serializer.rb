# == Schema Information
#
# Table name: posts_tags
#
#  id      :bigint           not null, primary key
#  post_id :bigint
#  tag_id  :bigint
#

class PostsTagSerializer < ActiveModel::Serializer
  attributes :id, :tag_name

  attribute :tag_name do
    object.tag.name
  end
end
