class Market
  attr_reader:name,
             :vendors
  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor.inventory.include?(item)
    end
  end

  def items_hash
    items_hash = Hash.new(0)
    @vendors.each do |vendor|
      vendor.inventory.each do |item, amount|
        items_hash[item] += amount
      end
    end
    items_hash
  end

  def total_inventory
    items_hash.map do |item,amount|
      info = {quantity: amount,
             vendors: vendors_that_sell(item)}
      [item, info]
    end.to_h
  end

  def overstocked_items
    items_hash.find_all do |item, amount|
      (amount > 50) && (vendors_that_sell(item).count > 1)
    end.to_h.keys 
  end
end
