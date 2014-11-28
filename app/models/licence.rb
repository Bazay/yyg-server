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
  EXPIRY_KEYS = [
    NO_EXPIRY,
    SHORT_EXPIRY,
    LONG_EXPIRY
  ]
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
  before_validation :generate_uniq_key, :set_default_licence_state

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
  scope :product_licences, -> { sub_licences.where('licences.product_id IS NOT NULL AND licences.sub_product_id IS NULL') }
  scope :sub_product_licences, -> { sub_licences.where('licences.sub_product_id IS NOT NULL') }
  
  ###---------- CLASS METHODS ---------###

  ###---------- INSTANCE METHODS ---------###
  def inactive?
    self.licence_state == LICENCE_STATE_INACTIVE
  end
  def set_to_active
    unless licence_state == LICENCE_STATE_ACTIVE
      self.update_attribute(:licence_state, LICENCE_STATE_ACTIVE)
      self.update_attribute(:activated_at, Time.current)
    end
  end
  def active?
    self.licence_state == LICENCE_STATE_ACTIVE
  end
  def set_to_revoked
    unless licence_state == LICENCE_STATE_REVOKED
      self.update_attribute(:licence_state, LICENCE_STATE_REVOKED)
      self.update_attribute(:revoked_at, Time.current)
    end
  end
  def revoked?
    self.licence_state == LICENCE_STATE_REVOKED
  end
  def set_to_expired
    unless licence_state == LICENCE_STATE_EXPIRED
      self.update_attribute(:licence_state, LICENCE_STATE_EXPIRED)
      self.update_attribute(:expired_at, Time.current)
    end
  end
  def expired?
    self.licence_state == LICENCE_STATE_EXPIRED
  end

  def set_expires_at(expiry_key)
    if EXPIRY_KEYS.include?(expiry_key)
      self.update_attribute(:expires_at, Time.current+EXPIRY_VALUES[expiry_key])
    else
      return false
    end
  end

  ###---------- PRIVATE METHODS ---------###
  private

  def generate_uniq_key
    if self.new_record?
      if self.key.blank?
        self.key = SecureRandom.uuid

        while (key_exists?(self.key))
          self.key = SecureRandom.uuid
        end
      end
    else
      if self.key != self.key_was && self.key_was.nil? == false
        errors.add(:key, "value cannot be changed once assigned")
      end
    end
  end

  def set_default_licence_state
    if self.new_record?
      self.licence_state = LICENCE_STATE_INACTIVE if self.licence_state.nil?
    end
  end

  def key_exists?(uuid)
    Licence.find_by_key(uuid).present?
  end

  def has_valid_relations
    #All sub_licences must be connected to either a product or a sub_product
    if licence_type == LICENCE_TYPE_SUB
      if self.product_id.nil? && self.sub_product_id.nil?
        errors.add(:base, "Licence Type 'Sub' be assigned to either a Product or Sub Product")
      elsif self.product_id.nil?
        errors.add(:base, "Licence Type 'Sub' be assigned to a product")        
      end
    elsif licence_type == LICENCE_TYPE_PARENT
      errors.add(:base, "Licence Type 'Parent' cannot be assigned to any Products or Sub Products") unless self.product_id.nil? && self.sub_product_id.nil?
    end
  end

end
