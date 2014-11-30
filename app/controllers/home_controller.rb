class HomeController < ApplicationController
  def index
    @setup = Product.count > 0
  end

  def overview
    @accounts = Account.includes(:products).includes(:sub_products).includes(:licences)
    @products = Product.all
    @sub_products = SubProduct.all
    @parent_licences = ParentLicence.all
    @sub_licences = SubLicence.all
  end
end
