class SubLicence < Licence

  #RELATIONS
  belongs_to :account
  belongs_to :product
  belongs_to :sub_product

  #SCOPES
  scope :product_licences, -> { where('licences.product_id IS NOT NULL AND licences.sub_product_id IS NULL') }
  scope :sub_product_licences, -> { where('licences.sub_product_id IS NOT NULL') }

  #VALIDATIONS
  validate :has_valid_relations

  #HOOKS
  after_create :generate_sub_product_licences
  
  ###---------- PRIVATE METHODS ---------###
  private

  def has_valid_relations
    #All sub_licences must be connected to either a product or a sub_product
    if self.product_id.nil? && self.sub_product_id.nil?
      errors.add(:base, "Licence Type 'Sub' be assigned to either a Product or Sub Product")
    elsif self.product_id.nil?
      errors.add(:base, "Licence Type 'Sub' be assigned to a product")        
    end
  end

  def generate_sub_product_licences
    licence = self
    if (product = licence.product) && licence.sub_product_id.nil?
      current_sub_product_ids = licence.account.sub_products.pluck(:id)
      #Create licences for sub_products of newly created product licence
      product.sub_products.each do |sub_product|
        #Must insure we do not create duplicate licences
        unless current_sub_product_ids.include?(sub_product.id)
          #Create licence for sub_productnew_accoun, inheriting from base product
          SubLicence.create(account: licence.account, sub_product: sub_product, product: product, licence_state: licence.licence_state, expires_at: licence.expires_at)
        end
      end
    end
  end


end
