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

require 'rails_helper'

RSpec.describe Post, type: :model do
  before(:each) do
    @user_01 = User.create(email: 'user_01@nightwatch.com', password: 'myNicePazwors1')
    @user_02 = User.create(email: 'user_02@nightwatch.com', password: 'myNicePazwors2')

    account = Account.create()

    Current.user = @user_02
    Current.account = account

    @post = Post.create(
      title: 'My first post',
      body: 'description',
      tags_manual: 'river    ,   nature ,   water ,  life'
      # user: Current.user, # auto-assign before create
      # slug: 'my-first-post', # auto with a callback
    )

    @answer = Post.new(
      title: @post.title + '-01',
      body: 'answer description',
      question_id: @post.id
    )
  end

  it 'is valid' do
    expect(@post.save).to be_truthy
  end

  it 'check slug' do
    @post.title = 'my first title IN TESTing'
    expect(@post.save).to be_truthy
    expect(@post.slug == 'my-first-title-in-testing').to be_truthy
  end

  it 'check different user saving than creator' do
    @post.user = @user_01
    expect(@post.save).to be_falsy
  end

  it 'cannot save two posts with the same title' do
    post_duplicate_title = Post.new(
      title: @post.title,
      body: 'description'
    )
    expect(post_duplicate_title.save).to be_falsy
  end

  it 'check tags' do
    post_tags = @post.posts_tags
    tags = @post.tags
    expect(post_tags.size == 4).to be_truthy
    expect(tags.size == 4).to be_truthy
  end

  it 'create answer description' do
    expect(@answer.save).to be_truthy
  end

  it 'cannot destroy post with answers' do
    expect(@answer.save).to be_truthy
    expect(@post.destroy).to be_falsy
  end

  it 'cannot destroy post different user than creator' do
    expect(@answer.save).to be_truthy
    @answer.user = @user_01
    expect(@post.destroy).to be_falsy
  end

  it 'check scopes for questions' do
  end

  it 'check scopes for answers' do
  end

  it 'check scopes for tags' do
  end
end
# binding.pry
