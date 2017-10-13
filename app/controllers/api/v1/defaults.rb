module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        prefix "api"
        version "v1", using: :path
        default_format :json
        format :json
        formatter :json, Grape::Formatter::ActiveModelSerializers

        helpers do
          def permitted_params
            @permitted_params ||= declared(params, include_missing: false)
          end

          def logger
            Rails.logger
          end

          def current_user
            @current_user ||= User.authorize!(params)
          end

          def authenticate_key!
            error!('Unauthorized. Invalid or expired api key.', 401) unless current_user
          end

          def authenticate!
            error!('Unauthorized. Invalid or expired token.', 401) unless current_user
          end
        end

        rescue_from CustomError::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        rescue_from Mongoid::Errors::InvalidFind do |e|
          error_response(message: e.message, status: 422)
        end
      end
    end
  end
end
