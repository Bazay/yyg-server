class Account < ActiveRecord::Base
  include SoftDelete

  attr_accessible :email, :registered_to, :deleted, :deleted_at

  #RELATIONS
  has_many :licences, :dependent => :destroy
  has_many :products, :through => :licences
  has_many :sub_products, :through => :licences

  #VALIDATIONS
  validate :has_maximum_one_parent_licence
  validates_uniqueness_of :email
  validates_presence_of :email

  #HOOKS
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

end
