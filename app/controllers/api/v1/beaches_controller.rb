module Api
  module V1
    class BeachesController < ExternalApiController
      def index
        return forbidden unless current_user.beach_admin?

        beaches = Store.beach.live

        render json: BeachSerializer.new(beaches).serialized_json
      end

      private

      def forbidden
        render json: {error: 'Forbidden'}, status: :forbidden
      end
    end
  end
end
