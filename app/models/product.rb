class Product < ActiveRecord::Base
  attr_accessible :base_price, :name, :product_type, :deleted, :deleted_at

  #CONSTANTS
  PRODUCT_TYPE_GAME_MAKER = "game_maker"
  PRODUCT_TYPES = [
    PRODUCT_TYPE_GAME_MAKER
  ]

  #RELATIONS
  has_many :licences

  #VALIDATIONS
  validates_inclusion_of :product_type, :in => PRODUCT_TYPES
  validates_numericality_of :base_price, :greater_than_or_equal_to => 0


end
