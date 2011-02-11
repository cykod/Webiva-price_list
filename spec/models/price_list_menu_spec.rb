require  File.expand_path(File.dirname(__FILE__)) + "/../price_list_spec_helper"

describe PriceListMenu do
  reset_domain_tables :price_list_menu

  it "should require a name" do
    @menu = PriceListMenu.new
    @menu.should have(1).error_on(:name)
  end
  
  it "should be able to create a menu" do
    @menu = PriceListMenu.create :name => "Test"
    @menu.id.should_not be_nil
  end
end
