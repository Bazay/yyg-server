class SubProduct < ActiveRecord::Base
  include SoftDelete

  attr_accessible :base_price, :name, :sub_product_type, :account

  #CONSTANTS
  SUB_PRODUCT_TYPE_EXPORT = "export"
  SUB_PRODUCT_TYPE_COMPILER = "compiler"
  SUB_PRODUCT_TYPES = [
    SUB_PRODUCT_TYPE_EXPORT,
    SUB_PRODUCT_TYPE_COMPILER
  ]

  #RELATIONS
  has_and_belongs_to_many :products
  has_many :accounts, :through => :sub_licences

  #VALIDATIONS
  validates_uniqueness_of :name
  validates_inclusion_of :sub_product_type, :in => SUB_PRODUCT_TYPES
  validates_numericality_of :base_price, :greater_than_or_equal_to => 0

  #SCOPES
  scope :export, -> { where('sub_products.sub_product_type = ?', SUB_PRODUCT_TYPE_EXPORT) }
  scope :compiler, -> { where('sub_products.sub_product_type = ?', SUB_PRODUCT_TYPE_COMPILER) }

end