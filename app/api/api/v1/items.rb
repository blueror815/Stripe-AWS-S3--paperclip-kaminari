module API
  module V1
    class Items < Grape::API
      include API::V1::Defaults
      helpers API::V1::SharedHelpers

      resource :items do

        desc 'Return all Items.'
        paginate max_per_page: 100
        get do
          authenticate!
          paginate(current_user.items.all().extend(ItemRepresenter.for_collection))
        end

        desc 'Return an Item.'
        params do
          requires :id, type: Integer, desc: 'Item id.'
        end
        route_param :id do
          get do
            authenticate!
            current_user.items.find(params[:id]).extend(ItemRepresenter)
          end
        end

        desc 'Create an Item.'
        params do
          requires :sync_uuid, type: String, desc: 'Unique ID used to identify the object within API clients.'
          requires :sku, type: String, desc: 'Item ID.'
          requires :quantity_on_hand, type: Integer, desc: 'Number of items on hand.'
          requires :quantity_on_road, type: Integer, desc: 'Number of items on road.'
          requires :quantity_sold, type: Integer, desc: 'Number of items sold.'
          requires :price, type: String, desc: 'Item Price.'
          requires :unit_cost, type: String, desc: 'Item Unit Cost.'
          requires :order_link, type: String, desc: 'Item re-order link.'
          requires :nickname, type: String, desc: 'Item nickname.'
          requires :item_description, type: String, desc: 'Item full description.'
          requires :full_name, type: String, desc: 'Item full name.'
          requires :is_road_merch, type: Boolean, desc: 'Item\'s road merch status.'
          optional :deleted_state, type: Boolean, default: false, desc: 'Item\'s deleted status.'
          optional :image, type: Rack::Multipart::UploadedFile, :desc => 'Image file.'
          optional :categories, type: Array do
            requires :name, type: String, desc: 'Name of category.'
            requires :ordering_identifier, type: Integer, desc: 'Used to order the categories in UI.'
            requires :deleted_state, type: Boolean, desc: 'Category\'s deleted state'
          end
        end
        post do
          begin
            authenticate!
            price = BigDecimal(params[:price])
            unit_cost = BigDecimal(params[:unit_cost])
            item = current_user.items.create({sync_uuid: params[:sync_uuid],
                                              sku: params[:sku],
                                              quantity_on_hand: params[:quantity_on_hand],
                                              quantity_on_road: params[:quantity_on_road],
                                              quantity_sold: params[:quantity_sold],
                                              price: price,
                                              unit_cost: unit_cost,
                                              order_link: params[:order_link],
                                              nickname: params[:nickname],
                                              item_description: params[:item_description],
                                              full_name: params[:full_name],
                                              is_road_merch: params[:is_road_merch],
                                              deleted_state: params[:deleted_state],
                                              image: params[:image]})
            item.save
            item.update_categories(params[:categories])
            item.extend(ItemRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
          end
        end

        desc 'Update an Item.'
        params do
          requires :id, type: Integer, desc: 'Item ID.'
          requires :sync_uuid, type: String, desc: 'Unique ID used to identify the object within API clients.'
          requires :sku, type: String, desc: 'Item Sku.'
          requires :quantity_sold, type: Integer, desc: 'Number of items sold.'
          requires :quantity_on_hand, type: Integer, desc: 'Number of items on hand.'
          requires :quantity_on_road, type: Integer, desc: 'Number of items on road.'
          requires :price, type: String, desc: 'Item Price.'
          requires :unit_cost, type: String, desc: 'Item Unit Cost.'
          requires :order_link, type: String, desc: 'Item re-order link.'
          requires :nickname, type: String, desc: 'Item nickname.'
          requires :item_description, type: String, desc: 'Item full description.'
          requires :full_name, type: String, desc: 'Item full name.'
          requires :is_road_merch, type: Boolean, desc: 'Item\'s road merch status.'
          optional :deleted_state, type: Boolean, default: false, desc: 'Item\'s deleted status.'
          optional :image, :type => Rack::Multipart::UploadedFile, :desc => 'Image file.'
          optional :categories, type: Array do
            requires :name, type: String, desc: 'Name of category.'
            requires :ordering_identifier, type: Integer, desc: 'Used to order the categories in UI.'
            requires :deleted_state, type: Boolean, default: false, desc: 'Category\'s deleted state'
          end
        end
        put ':id' do
          begin
            authenticate!
            item = current_user.items.find(params[:id])
            price = BigDecimal(params[:price])
            unit_cost = BigDecimal(params[:unit_cost])
            attributesHash = {sync_uuid: params[:sync_uuid],
                              sku: params[:sku],
                              quantity_sold: params[:quantity_sold],
                              quantity_on_hand: params[:quantity_on_hand],
                              quantity_on_road: params[:quantity_on_road],
                              price: price,
                              unit_cost: unit_cost,
                              order_link: params[:order_link],
                              nickname: params[:nickname],
                              item_description: params[:item_description],
                              full_name: params[:full_name],
                              is_road_merch: params[:is_road_merch]}
            attributesHash[:deleted_state] = params[:deleted_state] if params[:deleted_state]
            attributesHash[:image] = params[:image] if params[:image]

            item.update_categories(params[:categories])
            item.update(attributesHash)
            item.extend(ItemRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
          end
        end

        desc 'Delete an Item.'
        params do
          requires :id, type: Integer, desc: 'Item ID.'
        end
        delete ':id' do
          status 204
          authenticate!
          current_user.items.find(params[:id]).destroy.extend(ItemRepresenter)
        end

        desc 'Add image to Item.'
        params do
          requires :id, :type => Integer, desc: 'Item ID.'
          requires :image, :type => Rack::Multipart::UploadedFile, :desc => 'Image file.'
        end
        put ':id/image' do
          authenticate!
          item = current_user.items.find(params[:id])
          item.image = params[:image]
          item.save!
        end

      end

    end
  end
end
