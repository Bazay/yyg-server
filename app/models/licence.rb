class Licence < ActiveRecord::Base
  include SoftDelete

  attr_accessible :account_id, :account, :sub_product_id, :sub_product, :product_id, :product, :expired_at, :expires_at, :key, 
    :licence_state, :licence_type, :activated_at, :revoked_at, :deleted, :deleted_at

  #CONSTANTS
  #Licence States
  LICENCE_STATE_INACTIVE = 'inactive'
  LICENCE_STATE_ACTIVE = 'active'
  LICENCE_STATE_EXPIRED = 'expired'
  LICENCE_STATE_REVOKED = 'revoked'
  LICENCE_STATES = [
    LICENCE_STATE_INACTIVE, 
    LICENCE_STATE_ACTIVE, 
    LICENCE_STATE_EXPIRED, 
    LICENCE_STATE_REVOKED
  ]

  #Licence Types
  LICENCE_TYPE_PARENT = "parent_licence"
  LICENCE_TYPE_SUB = "sub_licence"
  LICENCE_TYPES = [
    LICENCE_TYPE_PARENT,
    LICENCE_TYPE_SUB
  ]

  #Licence Expiry Durations 
  # BB 27/11/14: To potentially facilitate a subscription-based system of licencing...
  NO_EXPIRY = 'no_expiry'
  SHORT_EXPIRY = 'short_expiry'
  LONG_EXPIRY = 'long_expiry'
  EXPIRY_VALUES = {
    SHORT_EXPIRY => 1.month, #Monthly
    LONG_EXPIRY => 1.year, #Annual
    NO_EXPIRY => nil #Default
  }

  #RELATIONS
  belongs_to :account
  belongs_to :product
  belongs_to :sub_product

  #HOOKS
  before_validation :generate_uniq_key, :set_licence_state
  before_create :set_default_expires_at

  #VALIDATIONS
  validates_presence_of :key, :licence_state, :licence_type, :account_id
  validates_uniqueness_of :key
  validates_inclusion_of :licence_state, :in => LICENCE_STATES
  validates_inclusion_of :licence_type, :in => LICENCE_TYPES
  validate :has_valid_relations

  #SCOPES
  #Licence States
  scope :active, -> { where('licences.licence_state = ?', LICENCE_STATE_ACTIVE) } 
  scope :inactive, -> { where('licences.licence_state = ?', LICENCE_STATE_INACTIVE) }
  scope :expired, -> { where('licences.licence_state = ?', LICENCE_STATE_EXPIRED) }
  scope :revoked, -> { where('licences.licence_state = ?', LICENCE_STATE_REVOKED) }
  #Account Related Scopes
  scope :parent_licences, -> { where('licences.licence_type = ?', LICENCE_TYPE_PARENT) }
  #Product Related Scopes
  scope :sub_licences, -> { where('licences.licence_type = ?', LICENCE_TYPE_SUB) }
  scope :product_licences, -> { sub_licences.where('licences.product_id IS NOT NULL') }
  scope :sub_product_licences, -> { sub_licences.where('licences.sub_product_id IS NOT NULL') }
  scope :export_licences, -> { sub_product_licences.includes(:sub_products).where('sub_products.sub_product_type = ?', SubProduct::SUB_PRODUCT_TYPE_EXPORT) }
  scope :compiler_licences, -> { sub_product_licences.includes(:sub_products).where('sub_products.sub_product_type = ?', SubProduct::SUB_PRODUCT_TYPE_COMPILER) }

  ###---------- CLASS METHODS ---------###

  ###---------- INSTANCE METHODS ---------###
  def set_to_active
    unless licence_state == LICENCE_STATE_ACTIVE
      self.update_attribute(:licence_state, LICENCE_STATE_ACTIVE)
      self.update_attribute(:activated_at, Time.current)
    end
  end
  def set_to_revoked
    unless licence_state == LICENCE_STATE_REVOKED
      self.update_attribute(:licence_state, LICENCE_STATE_REVOKED)
      self.update_attribute(:revoked_at, Time.current)
    end
  end
  def set_to_expired
    unless licence_state == LICENCE_STATE_EXPIRED
      self.update_attribute(:licence_state, LICENCE_STATE_EXPIRED)
      self.update_attribute(:expired_at, Time.current)
    end
  end

  def set_expires_at(expiry_key)
    self.update_attribute(:expires_at, Time.current+EXPIRY_VALUES[expiry_key])
  end

  ###---------- PRIVATE METHODS ---------###
  private

  def generate_uniq_key
    if key.blank?
      key = SecureRandom.uuid

      while (key_exists?(key))
        key = SecureRandom.uuid
      end
    end
  end

  #BB 27/11/14: WARNING! If no expiry 
  def set_default_expires_at
    self.expires_at = EXPIRY_VALUES[NO_EXPIRY] if self.expires_at.nil?
  end

  def set_default_licence_state
    self.licence_state = LICENCE_STATE_INACTIVE if self.licence_state.nil?
  end

  def key_exists?(uuid)
    Licence.find_by_key(uuid).present?
  end

  def has_valid_relations
    #All sub_licences must be connected to either a product or a sub_product
    if licence_type == LICENCE_TYPE_SUB
      errors.add(:base, "Licence Type 'Sub' must be assigned to a product or sub product") if product_id.nil? && sub_product_id.nil?
    elsif licence_type == LICENCE_TYPE_PARENT
      errors.add(:base, "Licence Type 'Parent' cannot be assigned to any products or sub products") unless product_id.nil? && sub_product_id.nil?
    end
  end

end
