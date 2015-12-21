module API
  module V1
    class Base < Grape::API
      mount API::V1::Auth
      mount API::V1::Users
      mount API::V1::Shows
      mount API::V1::ShowSales
      mount API::V1::Items
      mount API::V1::Sales
      mount API::V1::PromoCodes
      mount API::V1::Subscriptions
    end
  end
end