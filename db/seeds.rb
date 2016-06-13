# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#user = CreateAdminService.new.call
#puts 'CREATED ADMIN USER: ' << user.email
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

=begin
kcat_hash = { 1 => 'For The Home', 2=> 'Bed & Bath', 3=> 'Furniture', 4=> 'Women', 5=> 'Swin', 6=> 'Men', 7=> 'Teens', 8=> 'Kids', 9=> 'Baby', 10=> 'Shoes', 11=> 'Jewlery & Watches', 12=> 'Sports Fan Shop' }

kcat_hash.each do | id, cat_name |
  KohlsCategory.create!( name: cat_name, kc_id: id )
end
=end

konly_hash = {1 => 'Lauren Conrad', 2 => "Jennifer Lopez", 3 => 'Marc Anthony',
  4 => 'Gold Clearence', 5 => 'Rock & Republic', 6 => "Candie's", 7 => "Dana Buchman", 8 => "Elle" }

konly_hash.each do | id, only_name |
  KohlsOnly.create!( name: only_name, kc_id: id )
end
=begin
ktype_hash = { 1 => 'Dollar Off', 2 => 'Percent Off', 3 => 'Free Shipping', 4 => 'Coupon Code', 5 => 'General Promotion', 6=> 'Sitewide' }

ktype_hash.each do | id, type_name |
  KohlsType.create!( name: type_name, kc_id: id )
end
=end