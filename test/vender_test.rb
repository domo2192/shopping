require 'minitest/autorun'
require 'minitest/pride'
require './lib/item'
require './lib/vendor'
class VendorTest < Minitest::Test

  def setup
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @vendor = Vendor.new("Rocky Mountain Fresh")
  end

  def test_it_exists_and_has_attributes
    assert_instance_of Vendor, @vendor
    assert_equal "Rocky Mountain Fresh", @vendor.name
    expected = {}
    assert_equal expected, @vendor.inventory
  end

  def test_inventory_starts_at_0_and_stock_adds_to_it
    assert_equal 0, @vendor.check_stock(@item1)
    @vendor.stock(@item1, 30)
    assert_equal 30, @vendor.check_stock(@item1)
    expected = {@item1 => 30}
    assert_equal expected, @vendor.inventory
  end

  def test_we_can_add_multiple_items_and_amounts
    @vendor.stock(@item1, 30)
    @vendor.stock(@item1, 25)
    @vendor.stock(@item2, 12)
    expected = {@item1 => 55,
                @item2 => 12}
    assert_equal expected, @vendor.inventory
  end
end
