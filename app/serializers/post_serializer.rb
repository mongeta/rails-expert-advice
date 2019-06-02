# == Schema Information
#
# Table name: posts
#
#  id            :bigint           not null, primary key
#  title         :string
#  slug          :string
#  body          :string
#  user_id       :bigint
#  question_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  views_count   :integer          default(0)
#  answers_count :integer          default(0)
#  account_id    :bigint
#

class PostSerializer < ActiveModel::Serializer
  attributes :title, :slug, :body, :created_at, :question_id, :user_id, :answers_count, :views_count, :created_at, :updated_at, :tags_manual

  has_many :answers do
    link :related, Rails.application.routes.url_helpers.api_v1_answers_path(filter: { question: object.id }, format: 'json')
  end

  def tags_manual
    object.tags.map(&:name)
  end
end
