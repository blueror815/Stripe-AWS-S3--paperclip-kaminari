require 'roar/json'
require 'money'

module ArtistSalesRepresenter
  include Roar::JSON

  property :num_artist_sales
  property :sales, as: :artist_sales
  property :average_sale

  private

  def sales
    Money.new((artist_sales ? artist_sales : 0) * 100, 'USD').format
  end

  def average_sale
    return 0 if artist_sales == 0 && num_artist_sales == 0
    avg = artist_sales / num_artist_sales
    sprintf('%.2f', avg)
  end

end