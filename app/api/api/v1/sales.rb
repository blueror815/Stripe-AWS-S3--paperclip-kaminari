module API
  module V1
    class Sales < Grape::API
      include API::V1::Defaults
      helpers API::V1::SharedHelpers

      resource :sales do

        desc 'Return total artist Sales.'
        get 'all' do
          begin
            authenticate_uber_admin!
            count = Sale.all.count
            sales = Sale.sum(:amount)
            artist_sales = ArtistSales.new(num_artist_sales: count, artist_sales: sales)
            artist_sales.extend(ArtistSalesRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
            error!(e.to_s, 500)
          end
        end

        desc 'Return all Sales.'
        params do
          optional :show_id, type: Integer, desc: 'Show ID to pull sales data for.'
        end
        paginate max_per_page: 100
        get do
          authenticate!
          if (show_id = params[:show_id])
            paginate(current_user.sales.where(show_id: show_id).extend(SaleRepresenter.for_collection))
          else
            paginate(current_user.sales.all().extend(SaleRepresenter.for_collection))
          end
        end

        desc 'Return a Sale.'
        params do
          optional :id, type: Integer, desc: 'Sale id.'
        end
        route_param :id do
          get do
            authenticate!
            error!('Missing attribute ID.', 400) unless params[:id] || params[:show_id]
            current_user.sales.find(params[:id]).extend(SaleRepresenter)
          end
        end

        desc 'Create a Sale.'
        params do
          requires :sync_uuid, type: String, desc: 'Unique ID used to identify the object within API clients.'
          optional :tax, type: String, desc: 'Sale tax.'
          requires :amount, type: String, desc: 'Sale amount.'
          requires :invoice_id, type: String, desc: 'Sale invoice ID.'
          optional :discount, type: String, desc: 'Sale discount.'
          requires :date, type: DateTime, desc: 'Sale date.'
          requires :sale_type, type: String, desc: 'Sale type.'
          requires :deleted_state, type: Boolean, desc: 'Sale deleted state.'
          optional :show_id, type: Integer, desc: 'The corresponding Show ID.'
          optional :cart_items, type: Array, desc: 'The items sold in the Sale.' do
            requires :quantity_in_cart, type: Integer, desc: 'Quantity of the item sold.'
            requires :item, type: Hash, desc: 'The details of the Item sold.' do
              optional :id, type: Integer, desc: 'Item ID.'
              optional :sync_uuid, type: String, desc: 'Unique ID used to identify the object within API clients.'
            end
          end
        end
        post do
          begin
            authenticate!
            sale_params = {sync_uuid: params[:sync_uuid],
                           amount: BigDecimal(params[:amount]),
                           invoice_id: params[:invoice_id],
                           date: params[:date],
                           sale_type: params[:sale_type],
                           deleted_state: params[:deleted_state]}

            sale_params[:tax] = BigDecimal(params[:tax]) if params[:tax]
            sale_params[:discount] = BigDecimal(params[:discount]) if params[:discount]

            sale = current_user.sales.create(sale_params)

            show_id = params[:show_id]
            if show_id && (show = Show.find_by_id(show_id))
              sale.show = show
            end

            for ci in params[:cart_items]
              cart_item = sale.cart_items.create({quantity_in_cart: ci[:quantity_in_cart]})
              item_id = ci[:item][:id]
              sync_uuid = ci[:item][:sync_uuid]
              if item_id && (item = Item.find_by_id(item_id))
                cart_item.item = item
              elsif sync_uuid && (item = Item.find_by_sync_uuid(sync_uuid))
                cart_item.item = item
              end
              cart_item.save
            end

            sale.save
            sale.extend(SaleRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
          end
        end

        desc 'Update a Sale.'
        params do
          requires :id, type: Integer, desc: 'Sale ID.'
          requires :sync_uuid, type: String, desc: 'Unique ID used to identify the object within API clients.'
          optional :tax, type: String, desc: 'Sale tax.'
          requires :amount, type: String, desc: 'Sale amount.'
          requires :invoice_id, type: String, desc: 'Sale invoice ID.'
          optional :discount, type: String, desc: 'Sale discount.'
          requires :date, type: DateTime, desc: 'Sale date.'
          requires :sale_type, type: String, desc: 'Sale type.'
          requires :deleted_state, type: Boolean, desc: 'Sale deleted state.'
          optional :show_id, type: Integer, desc: 'The corresponding Show ID.'
        end
        put ':id' do
          begin
            authenticate!
            sale = current_user.sales.find(params[:id])
            sale_params = {sync_uuid: params[:sync_uuid],
                           amount: BigDecimal(params[:amount]),
                           invoice_id: params[:invoice_id],
                           date: params[:date],
                           sale_type: params[:sale_type],
                           deleted_state: params[:deleted_state]}

            sale_params[:tax] = BigDecimal(params[:tax]) if params[:tax]
            sale_params[:discount] = BigDecimal(params[:discount]) if params[:discount]

            show_id = params[:show_id]
            if show_id && (show = Show.find_by_id(show_id))
              sale.show = show
            end

            sale.update(sale_params)
            sale.extend(SaleRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
          end
        end

        desc 'Delete a Sale.'
        params do
          requires :id, type: Integer, desc: 'Sale ID.'
        end
        delete ':id' do
          status 204
          authenticate!
          current_user.sales.find(params[:id]).destroy.extend(SaleRepresenter)
        end

      end

    end
  end
end
