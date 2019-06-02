module Api
  module V1
    class PostsController < Api::V1::ApiController
      before_action :doorkeeper_authorize!, except: %i[index show]

      def index
        posts = Post.questions.with_tags(params.dig(:filter, :tags)).includes(:answers).order(:created_at)
        paginate json: posts
      end

      def show
        post = Post.find_by(slug: params[:slug])

        if post
          post.update_columns(views_count: post.views_count + 1)
          render json: post, include: :posts_tags
        else
          head 404
        end
      end

      def create
        post = Post.new(post_params)

        if post.save
          render json: post
        else
          render json: post,
                 status: :unprocessable_entity,
                 serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def update
        @post = Post.find(params[:data][:id])

        if @post.update_attributes(post_params)
          render json: @post
        else
          render json: @post,
                 status: :unprocessable_entity,
                 serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def destroy
        post = Post.find(params[:slug])

        if post.destroy
          head :no_content
        else
          render json: post,
                 status: :unprocessable_entity,
                 serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      private

      def post_params
        params.require(:data).require(:attributes).permit(:id, :title, :body, :tags_manual)
      end

    end
  end
end
