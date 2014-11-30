class Account < ActiveRecord::Base
  include SoftDelete

  attr_accessible :email, :registered_to, :deleted, :deleted_at

  #CONSTANTS
  VALID_EMAIL_REGEX = /^[^@\s"']+@([^@\.\s"']+\.)+[^@\.\s"']+$/

  #RELATIONS
  has_many :licences, :dependent => :destroy
  has_many :sub_licences, :dependent => :destroy
  has_one :parent_licence, :dependent => :destroy
  has_many :products, :through => :sub_licences
  has_many :sub_products, :through => :sub_licences

  #VALIDATIONS
  validates_uniqueness_of :email
  validates_format_of :email, with: VALID_EMAIL_REGEX
  validates_presence_of :email

  #HOOKS
  before_create :generate_parent_licence

  #SCOPES
  ###---------- CLASS METHODS ---------###
  def self.find_by_parent_key(key)
    #NB* Consider storing parent_licence.key in the account model to reduce database lookups...
    includes(:parent_licence).where('licences.key = ?',key).first
  end

  ###---------- INSTANCE METHODS ---------###
  def get_account_state
    parent_licence.licence_state
  end
  def products
    @products = Product.includes(:licences).where('licences.type = ? AND licences.account_id = ? AND licences.product_id IS NOT NULL AND licences.sub_product_id IS NULL',Licence::LICENCE_TYPE_SUB,self.id)
  end

  #Shortened calls
  def product_licences
    sub_licences.product_licences
  end
  def sub_product_licences
    sub_licences.sub_product_licences
  end
  def products_and_sub_products
    products.includes(:sub_products)
  end

  #NB* Rails 3 doesn't fully support associations with Classes that inherit, so unfortunately
  # we cannot use parent_licence.build :(
  # This is a work around.
  def build_sub_licence(attrs)
    licences << SubLicence.new(attrs)
  end

  ###---------- PRIVATE METHODS ---------###
  private

  def generate_parent_licence
    #NB* Rails 3 doesn't fully support associations with Classes that inherit, so unfortunately
    # we cannot use parent_licence.build :(
    # This is a work around.
    licences.build(type: Licence::LICENCE_TYPE_PARENT)
  end

end
