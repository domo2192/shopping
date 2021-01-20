require 'minitest/autorun'
require 'minitest/pride'
require './lib/item'
require './lib/vendor'
require './lib/market'

class MarketTest < Minitest::Test

  def setup
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @vendor = Vendor.new("Rocky Mountain Fresh")
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor3 = Vendor.new("Palisade Peach Shack")
    @market = Market.new("South Pearl Street Farmers Market")
  end

  def test_it_exists_and_has_attributes
    assert_instance_of Market, @market
    assert_equal "South Pearl Street Farmers Market", @market.name
    assert_equal [], @market.vendors
  end

  def test_we_can_add_vendors
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @marktet.add_vendor(@vendor3)
    assert_equal [@vendor1, @vendor2, @vendor3], @market.vendors 
  end
end
