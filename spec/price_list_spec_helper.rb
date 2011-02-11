require  File.expand_path(File.dirname(__FILE__)) + "/../../../../spec/spec_helper"

Factory.define(:price_list_menu) do |d|
  d.sequence(:name) { |n| "price list menu #{n}" }
end

Factory.define(:price_list_section) do |d|
  d.sequence(:name) { |n| "price list section #{n}" }
  d.association :price_list_menu, :factory => :price_list_menu
end

Factory.define(:price_list_item) do |d|
  d.sequence(:name) { |n| "price list item #{n}" }
  d.association :price_list_section, :factory => :price_list_section
end

