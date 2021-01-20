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
  end
end
