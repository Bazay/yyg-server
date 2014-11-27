class Product < ActiveRecord::Base
  include SoftDelete

  attr_accessible :base_price, :name, :product_type, :deleted, :deleted_at

  #CONSTANTS
  PRODUCT_TYPE_GAME_MAKER = "game_maker"
  PRODUCT_TYPES = [
    PRODUCT_TYPE_GAME_MAKER
  ]

  #RELATIONS
  has_many :licences
  has_many :accounts, :through => :licences
  has_many :sub_products

  #VALIDATIONS
  validates_uniqueness_of :name
  validates_inclusion_of :product_type, :in => PRODUCT_TYPES
  validates_numericality_of :base_price, :greater_than_or_equal_to => 0

  scope :game_maker, -> { where('products.product_type = ?', PRODUCT_TYPE_GAME_MAKER) }

end
