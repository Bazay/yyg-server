class LicenceObserver < ActiveRecord::Observer

  #Responsible for creating licence for sub_products
  def after_create(licence)
    if product = licence.product
      current_sub_product_ids = product.account.licences.sub_product_licences.pluck(:sub_product_ids)
      #Create licences for sub_products of newly created product licence
      product.sub_products.each do |sub_product|
        #Must insure we do not create duplicate licences
        unless current_sub_product_ids.include?(sub_product.id)
          #Create licence for sub_product, inheriting from base product
          Licence.create(account: product.account, sub_product: sub_product, licence_state: licence.licence_state, expires_at: licence.expires_at)
        end
      end
    end
  end

end