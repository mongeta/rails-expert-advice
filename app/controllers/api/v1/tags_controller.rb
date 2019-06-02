module Api
  module V1
    class TagsController < Api::V1::ApiController
      def index
        tags = Tag.all
        render json: tags
      end

      def show
        tag = Tag.find(params[:id])
        render json: tag
      end
    end
  end
end
