module API
  module V1
    class ShowSales < Grape::API
      include API::V1::Defaults
      helpers API::V1::SharedHelpers

      resource 'shows/:id/sales' do

        desc 'Return all Sales for a specific Show.'
        params do
          requires :id, type: Integer, desc: 'Show ID to pull sales data for.'
        end
        paginate max_per_page: 100
        get do
          authenticate!
          sales = current_user.shows.find(params[:id]).sales
          paginate(sales.extend(SaleRepresenter.for_collection))
        end

      end

    end
  end
end
