module Api
  module V1
    class AnswersController < Api::V1::ApiController
      before_action :doorkeeper_authorize!, except: :index

      def index
        posts = Post.with_answers(params.dig(:filter, :question)).order(:created_at)
        render json: posts, each_serializer: ActiveModel::Serializer::AnswerSerializer
      end

      def show
        answer = Post.find_by(slug: params[:slug])

        if answer
          render json: answer, include: :posts_tags, serializer: ActiveModel::Serializer::AnswerSerializer
        else
          head 404
        end
      end

      def create
        answer = Post.new(answer_params)

        if answer.save
          render json: answer
        else
          render json: answer,
                 status: :unprocessable_entity,
                 serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def update
        @answer = Post.find(params[:data][:id])

        if @answer.update_attributes(answer_params)
          render json: @answer
        else
          render json: @answer,
                 status: :unprocessable_entity,
                 serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def destroy
        answer = Post.find(params[:slug])

        if answer.destroy
          head :no_content
        else
          render json: answer,
                 status: :unprocessable_entity,
                 serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      private

      def answer_params
        params.require(:data).require(:attributes).permit(:question_id, :body)
      end
    end
  end
end
