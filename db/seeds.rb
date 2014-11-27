# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Products
##
game_maker = Product::PRODUCT_TYPE_GAME_MAKER
gm_studio = Product.create( base_price: 0, name: "Standard", product_type: game_maker )
gm_professional = Product.create( base_price: 49.99, name: "Professional", product_type: game_maker )
gm_master = Product.create( base_price: 799.99, name: "Master", product_type: game_maker )

#Sub-Products
##Types
export = SubProduct::PRODUCT_TYPE_EXPORT
compiler = SubProduct::SUB_PRODUCT_TYPE_COMPILER
#Sub Products
wd = SubProduct.create( base_price: 0, name: "Windows Desktop Export", product_type: export)
wa = SubProduct.create( base_price: 0, name: "Windows App Export", product_type: export)
mac_os = SubProduct.create( base_price: 99.99, name: "Mac OS X Export", product_type: export)
ubuntu = SubProduct.create( base_price: 99.99, name: "Ubuntu Export", product_type: export)
html5 = SubProduct.create( base_price: 99.99, name: "HTML5 Export", product_type: export)
android = SubProduct.create( base_price: 199.99, name: "Android Export", product_type: export)
ios = SubProduct.create( base_price: 199.99, name: "iOS Export", product_type: export)
wp8 = SubProduct.create( base_price: 199.99, name: "Windows Phone 8 Export", product_type: export)
tizen = SubProduct.create( base_price: 199.99, name: "Tizen Export", product_type: export)
yyc = SubProduct.create( base_price: 299.99, name: "YoYo Compiler", product_type: compiler)
xbox_one = SubProduct.create( base_price: 299.99, name: "Xbox One Export", product_type: export)
ps4 = SubProduct.create( base_price: 299.99, name: "PlayStation 4 Export", product_type: export)
psv = SubProduct.create( base_price: 299.99, name: "PlayStation Vita Export", product_type: export)
ps3 = SubProduct.create( base_price: 299.99, name: "PlayStation 3 Export", product_type: export)

#Product Relations
gm_studio.sub_products << [ wd ]
gm_professional.sub_products << [ wd, wa ]
gm_professional.sub_products << [ wd, wa, mac_os, ubuntu, html5, android, ios, wp8, tizen, yyc, xbox_one, ps4, ps3, psv ]

#Accounts
standard_user = Account.create(email: "standard@user.com", registered_to: "Standard User")
professional_base_user = Account.create(email: "professional_base@user.com", registered_to: "Professional Base User")
professional_extended_user = Account.create(email: "professional_extended@user.com", registered_to: "Professional Extended User")

#Connect Accounts to Products through Licences
standard_licence = Licence.create(product: gm_studio, account: standard_user)
standard_licence.set_to_active
professional_base_licence = Licence.create(product: gm_professional, account: professional_base_user)
professional_base_licence.set_to_active
professional_extended_licence = Licence.create(product: professional_extended_user, account: professional_extended_user)
professional_extended_licence.set_to_active
