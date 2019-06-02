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

class Post < ApplicationRecord
  belongs_to :user
  belongs_to :account

  belongs_to :question, class_name: 'Post', foreign_key: :question_id, optional: true
  has_many :answers, class_name: 'Post', foreign_key: :question_id
  has_many :posts_tags, dependent: :destroy
  has_many :tags, through: :posts_tags

  scope :questions, -> { where(question_id: nil) }
  scope :with_tags, lambda { |tags|
    if tags
      includes(:tags).joins(:tags).where(tags: { id: Tag.select(:id).where(name: tags.split(',').map(&:strip)) })
    else
      includes(:tags)
    end
  }

  scope :with_answers, lambda { |question_id|
                         if question_id
                           where(question_id: question_id)
                         else
                           Post.none
                         end
                       }

  attr_accessor :tags_manual

  validates :title, presence: true, uniqueness: true
  validates :body, presence: true
  validates :user, presence: true

  before_validation :before_validation_default
  before_save :update_slug
  after_save :after_save_default

  before_destroy :check_post_belongs_to_current_user, :check_has_answers
  before_update :check_post_belongs_to_current_user
  after_destroy :after_destroy_default

  private

  def question?
    question_id.nil?
  end

  def answer?
    question_id != nil
  end

  def update_slug
    self.slug = title.parameterize
  end

  def update_tags
    tags_to_be_deleted = posts_tags

    cast_tags.each do |tag_to_add|
      tag = Tag.find_or_create_by(name: tag_to_add)
      post_tag = PostsTag.find_or_create_by(tag: tag, post: self)
      tags_to_be_deleted = tags_to_be_deleted.reject { |tag_current| tag_current == post_tag }
    end

    # now we have to delete the tags that previously existed and now not
    tags_to_be_deleted.each(&:destroy)
    posts_tags.reload # because we have been changing the selection for PostTag, restore as it was
  end

  def check_post_belongs_to_current_user
    return if Current.user == user

    errors[:base] << 'You are not the creator of this post'
    throw(:abort)
  end

  def check_has_answers
    return if answers.empty?

    errors[:base] << 'This question has answers and can not be deleted'
    throw(:abort)
  end

  def cast_tags(tags = tags_manual)
    return [] if tags.nil?

    tags.split(',').map(&:strip)
  end

  def answers_count_update(how_many = 1)
    # question.update_columns(views_count: question.views_count + how_many, answers_count: question.answers_count + how_many)
    question.update_columns(answers_count: question.answers_count + how_many)
  end

  def view_count_update(how_many = 1)
    question.views_count += how_many
  end

  def after_save_default
    if question?
      update_tags # only questions have tags
    elsif id_previously_changed?
      answers_count_update(1)
    end
  end

  def after_destroy_default
    # if was an answer, counter down
    answers_count_update(-1) unless question_id_was.blank?
  end

  def before_validation_default
    # set user && account when they are nil (when they are new)
    # we are using the slug as the id, so we cannot have two slugs equals
    # when we save the answer, we have to use the same slug as the question
    # with some minor changes
    self.user = Current.user if user.nil?
    self.account = Current.account if account.nil?
    self.title = "#{question.title} - #{question.views_count} - #{question.answers_count}" if answer? && title.nil?
  end
end
