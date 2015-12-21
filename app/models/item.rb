class Item < ActiveRecord::Base

  belongs_to :user
  has_many :categories, dependent: :destroy
  has_many :cart_items

  has_attached_file :image, styles: {
      thumb: '100x100>',
      square: '200x200#',
      medium: '300x300>'
  }

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def update_categories(categories_params)
    if categories_params
      delete_categories = []
      categories.each { |_category| delete_categories << _category }
      categories_params.each do |category_json|
        begin
          if category = categories.find_by_name(category_json[:name])
            delete_categories -= [category]
            category.update({
              name: category_json[:name],
              ordering_identifier: category_json[:ordering_identifier],
              deleted_state: category_json[:deleted_state]
            })
          else
            save if changed?
            categories.create({
              name: category_json[:name],
              ordering_identifier: category_json[:ordering_identifier],
              deleted_state: category_json[:deleted_state]
            }).save
          end

          save if changed?
        rescue Exception => e
          Raygun.track_exception(e)
        end
      end
      delete_categories.each { |_category| _category.delete }
    end
  end

end
