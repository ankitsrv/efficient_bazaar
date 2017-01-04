##################################################
#                                                #
#           Assumptions                          #
#                                                #
# Assumption 1 - CSV file is small enough to fit into the RAM. Otherwise will have to use external database.
# Assumption 2 - First row of csv will be headers names(id, vendor, product name ..etc).
# Assumption 3 - This Ruby Code script residing in the same directory as products.csv file
# Assumption 4 - Ruby 2.3.0 installed in the running system

####################################
#
#       Instructions To run
#
# 1. Open terminal and Go to the directory where this ruby(.rb) file exists.
# 2. run $<ruby temp_code.rb> <enter>
# 3. The output will be array of cheapest prices, expensive prices and cheapest prices for selective products

##################################

# product class , have attributes id, vendor, name.. etc

class Product
  attr_accessor :id, :vendor, :name, :code, :unit, :weight, :price # will create getter and setter methods

  # constructor method of product class
  def initialize(product_options={})
    @id = product_options["Id"]
    @vendor = product_options["Vendor"]
    @name = product_options["Product Name"]
    @code = product_options["Product Code"]
    @unit = product_options["Unit"]
    @weight = product_options["Weight"]
    @price = product_options["Price"]
  end

  # class method to return all objects of product class
  def self.all
    ObjectSpace.each_object(self).to_a
  end

  # class method to return product object by object_id
  def self.fetch_obj(object_id=nil)
    obj = ObjectSpace._id2ref(object_id)
    [obj.id, obj.vendor, obj.name, obj.code, obj.unit, obj.weight, obj.price]
  end

end


# method to parse CSV file , everything is happening in this method,
# it will take csv file name or file path and return
# cheapest price, expensive price and cheapest price for selected products

def csv_parser(csv_options=nil)
  product_hash_array = []
  CSV.foreach(csv_options, headers: true) do |row|
    product_hash_array << row.to_h
  end
  product_hash_array.each do |product_hash|
    Product.new(product_hash)
  end

  products_all = Product.all
  cheapest_price_hash = {}
  expensive_price_hash = {}
  cheapest_prices_selective_array = []
  products_array = [3736, 4356, 3732, 3746, 3759, 3719, 3740, 4341]


  products_all.each do |product|
    product_code = product.code
    if cheapest_price_hash[product_code] == nil
      cheapest_price_hash[product_code] = [product.price, product.object_id]
    end
    if expensive_price_hash[product_code] == nil
      expensive_price_hash[product_code] = [product.price, product.object_id]
    end
    unless cheapest_price_hash[product_code][0] < product.price
      cheapest_price_hash[product_code] = [product.price, product.object_id]
    end
    if expensive_price_hash[product_code][0] < product.price
      expensive_price_hash[product_code] = [product.price, product.object_id]
    end

  end

  products_array.each do |product_code|
    cheapest_prices_selective_array << cheapest_price_hash[product_code.to_s][1]
  end

  puts "\nCheapest Prices\n\n"
  cheapest_price_hash = cheapest_price_hash.collect {|k,v| Product.fetch_obj(v[1]).inspect}
  puts cheapest_price_hash.each {|product| product.inspect}

  puts "\nExpensive Prices\n\n"
  expensive_price_hash = expensive_price_hash.collect {|k,v| Product.fetch_obj(v[1]).inspect}
  puts expensive_price_hash.each {|product| product.inspect}

  puts "\nCheapest Prices for selected Product Codes\n\n"
  cheapest_prices_selective_array = cheapest_prices_selective_array.collect {|product_id| Product.fetch_obj(product_id).inspect }
  puts cheapest_prices_selective_array.each {|product| product.inspect}

end

############################################

# it will require ruby's csv library
require 'csv'

# configurable file_name, currently hard coded
csv_path = "products.csv"

# just call this method
csv_parser(csv_path)



