require 'minitest/autorun'
require 'minitest/pride'
require './lib/item'
require './lib/vendor'
require './lib/market'
require 'mocha/minitest'
require 'date'

class MarketTest < Minitest::Test

  def setup
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor3 = Vendor.new("Palisade Peach Shack")
    @market = Market.new("South Pearl Street Farmers Market")
    @item5 = Item.new({name: 'Onion', price: '$0.25'})
  end

  def test_it_exists_and_has_attributes
    assert_instance_of Market, @market
    assert_equal "South Pearl Street Farmers Market", @market.name
    assert_equal [], @market.vendors
  end

  def test_we_can_add_vendors
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    assert_equal [@vendor1, @vendor2, @vendor3], @market.vendors
  end

  def test_vendor_names
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    assert_equal ["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"], @market.vendor_names
  end

  def test_vendors_that_sell
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    assert_equal [@vendor1, @vendor3], @market.vendors_that_sell(@item1)
    assert_equal [@vendor2], @market.vendors_that_sell(@item4)

  end

  def test_potential_revenue_for_vendors
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    assert_equal 29.75, @vendor1.potential_revenue
    assert_equal 345.00, @vendor2.potential_revenue
    assert_equal 48.75, @vendor3.potential_revenue
  end

  def test_items_hash_helper
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @vendor3.stock(@item3, 10)
    expected = {@item1 => 100,
                @item2 => 7,
                @item4 => 50,
                @item3 => 35}
    assert_equal expected, @market.items_hash
  end

  def test_total_inventory
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @vendor3.stock(@item3, 10)
    expected = {
       @item1 => {
         quantity: 100,
         vendors: [@vendor1, @vendor3]
       },
       @item2 => {
         quantity: 7,
         vendors: [@vendor1]
       },
       @item4 => {
         quantity: 50,
         vendors: [@vendor2]
       },
       @item3 => {
         quantity: 35,
         vendors: [@vendor2, @vendor3]
       },
     }
     assert_equal expected, @market.total_inventory
  end

  def test_overstocked_items
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @vendor3.stock(@item3, 10)
    assert_equal [@item1], @market.overstocked_items
  end

  def test_sorted_item_list
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @vendor3.stock(@item3, 10)
    assert_equal ["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"], @market.sorted_item_list
  end

  def test_date_method_for_market
    Date.stubs(:today).returns(Date.new(2020, 02, 24))
    assert_equal "24/02/2020", @market.date
  end

  def test_sell_method_returns_true_and_false
   @market.add_vendor(@vendor1)
   @market.add_vendor(@vendor2)
   @market.add_vendor(@vendor3)
   @vendor1.stock(@item1, 35)
   @vendor1.stock(@item2, 7)
   @vendor2.stock(@item4, 50)
   @vendor2.stock(@item3, 25)
   @vendor3.stock(@item1, 65)
   assert_equal false, @market.sell(@item1, 200)
   assert_equal false , @market.sell(@item5, 1)
   assert_equal true, @market.sell(@item4, 5)
   assert_equal 45, @vendor2.check_stock(@item4)
   assert_equal true, @market.sell(@item1, 40)
   assert_equal 0, @vendor1.check_stock(@item1)
   assert_equal 60, @vendor3.check_stock(@item1)
  end
end
