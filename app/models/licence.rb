class Licence < ActiveRecord::Base
  attr_accessible :expired_at, :expires_at, :key, :licence_state, :licence_type

  #CONSTANTS
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

  LICENCE_TYPE_PARENT = "parent_licence"
  LICENCE_TYPE_SUB = "sub_licence"
  LICENCE_TYPES = [
    LICENCE_TYPE_PARENT
    LICENCE_TYPE_CHILD
  ]

  #RELATIONS
  belongs_to :account
  belongs_to :product
  belongs_to :sub_product

  #CALLBACKS
  before_validation :generate_uniq_key
  before_create :set_expires_at, :set_licence_state

  #VALIDATIONS
  validates_presence_of :key, :licence_state, :licence_type
  validates_inclusion_of :licence_state, :in => LICENCE_STATES
  validates_inclusion_of :licence_type, :in => LICENCE_TYPES

  private

  def generate_uniq_key
  end

  def set_expires_at
  end

  def set_licence_state
  end
end
