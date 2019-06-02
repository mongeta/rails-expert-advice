# == Schema Information
#
# Table name: posts
#
#  id          :bigint           not null, primary key
#  title       :string
#  slug        :string
#  body        :string
#  user_id     :bigint
#  question_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AnswerSerializer < ActiveModel::Serializer
  type 'answers'
  attributes :body, :question_id, :slug, :user_id, :created_at, :updated_at # , :question

  has_one :question do
    link :related, Rails.application.routes.url_helpers.api_v1_post_path(object.question.slug, format: 'json')
  end
end
