class SubProduct < ActiveRecord::Base
  attr_accessible :base_price, :name, :sub_product_type

  #CONSTANTS
  SUB_PRODUCT_TYPE_EXPORT = "export"
  SUB_PRODUCT_TYPE_COMPILER = "compiler"
  SUB_PRODUCT_TYPES = [
    SUB_PRODUCT_TYPE_EXPORT,
    SUB_PRODUCT_TYPE_COMPILER
  ]
end
