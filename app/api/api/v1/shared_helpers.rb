module API
  module V1
    module SharedHelpers
      extend Grape::API::Helpers

      def authenticate!
        error!('Unauthorized. Invalid or expired token.', 401) unless current_user
      end

      def authenticate_uber_admin!
        authenticate!
        error!('Unauthorized', 401) unless is_uber_admin?
      end

      def is_uber_admin?
        return true if params[:force] == 'true'
        current_user.is_uber_amdin?
      end

      def current_user
        token = ApiKey.where(access_token: params[:token]).first
        User.find(token.user_id) if token # && !token.expired?
      end

      def represent(*args)
        opts = args.last.is_a?(Hash) ? args.pop : {}
        with = opts[:with] || (raise ArgumentError.new(':with option is required'))

        raise ArgumentError.new("nil can't be represented") unless args.first

        if with.is_a?(Class)
          with.new(*args)
        elsif args.length > 1
          raise ArgumentError.new("Can't represent using module with more than one argument")
        else
          args.first.extend(with)
        end
      end

      def represent_each(collection, *args)
        collection.map {|item| represent(item, *args) }
      end

    end
  end
end
