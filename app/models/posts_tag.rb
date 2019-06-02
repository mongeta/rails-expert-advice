# == Schema Information
#
# Table name: posts_tags
#
#  id      :bigint           not null, primary key
#  post_id :bigint
#  tag_id  :bigint
#

class PostsTag < ApplicationRecord
  belongs_to :post
  belongs_to :tag
end
