require 'active_support/concern'

module SoftDelete
  extend ActiveSupport::Concern

  def destroy
    unless (deleted)
      update_column(:deleted, true)
      update_column(:deleted_at, Time.current)
      run_callbacks :destroy
    end
  end

  included do
    default_scope :conditions => { deleted: false }
  end
end