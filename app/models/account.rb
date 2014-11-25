class Account < ActiveRecord::Base
  attr_accessible :account_status, :email, :registered_to

  #CONSTANTS
  ACCOUNT_STATUS = "active"

  #RELATIONS
  has_many :licences
  has_many :products, :through => :licences
  has_many :sub_products, :through => :licences

end
