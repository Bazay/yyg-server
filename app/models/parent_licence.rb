class ParentLicence < Licence

  #RELATIONS
  #Inherited from Licence

  #VALIDATIONS
  validate :has_valid_relations

  ###---------- PRIVATE METHODS ---------###
  private

  def has_valid_relations
    errors.add(:base, "Cannot be assigned to any Products or Sub Products") unless self.product_id.nil? && self.sub_product_id.nil?
  end
end