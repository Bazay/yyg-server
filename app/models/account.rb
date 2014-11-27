class Account < ActiveRecord::Base
  include SoftDelete

  attr_accessible :account_status, :email, :registered_to, :deleted, :deleted_at

  #CONSTANTS
  ACCOUNT_STATUSES = [
    ACCOUNT_STATUS_INACTIVE = "inactive"
    ACCOUNT_STATUS_ACTIVE = "active"
  ]

  #RELATIONS
  has_many :licences
  has_many :products, :through => :licences
  has_many :sub_products, :through => :licences

  #VALIDATIONS
  validate :has_maximum_one_parent_licence
  validates_uniqueness_of :email
  validates_presence_of :email, :account_status
  validates_inclusion_of :account_status, :in => ACCOUNT_STATUSES

  #HOOKS
  before_validation :set_default_account_status
  before_create :generate_parent_licence

  ###---------- CLASS METHODS ---------###

  ###---------- INSTANCE METHODS ---------###
  def parent_licence
    licences.parent_licences.first #Should only return one object
  end
  def sub_licences
    licences.sub_licences
  end

  ###---------- PRIVATE METHODS ---------###
  private

  def generate_parent_licence
    licences.build(licence_type: Licence::LICENCE_TYPE_PARENT)
  end
  def has_maximum_one_parent_licence
    errors.add(:base, "Can have maximum 1 parent licence") if licences.parent_licences.count > 1
  end
  def set_default_account_status
    account_status = ACCOUNT_STATUS_INACTIVE if account_status.nil?
  end

end
