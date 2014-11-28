class LicenceObserver < ActiveRecord::Observer

  #Responsible for creating licence for sub_products
  def after_create(licence)
    if (product = licence.product) && licence.sub_product_id.nil?
      current_sub_product_ids = licence.account.licences.sub_product_licences.pluck(:sub_product_id)
      #Create licences for sub_products of newly created product licence
      product.sub_products.each do |sub_product|
        #Must insure we do not create duplicate licences
        unless current_sub_product_ids.include?(sub_product.id)
          #Create licence for sub_productnew_accoun, inheriting from base product
          Licence.create(account: licence.account, sub_product: sub_product, product: product, licence_state: licence.licence_state, licence_type: Licence::LICENCE_TYPE_SUB, expires_at: licence.expires_at)
        end
      end
    end
  end

end