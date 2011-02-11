require  File.expand_path(File.dirname(__FILE__)) + "/../price_list_spec_helper"

describe PriceListSection do
  reset_domain_tables :price_list_menu, :price_list_section, :price_list_item

  it "should require a name and menu" do
    @menu = PriceListSection.new
    @menu.should have(1).error_on(:name)
    @menu.should have(1).error_on(:price_list_menu_id)
  end
  
  describe "Menu" do
    before(:each) do
      @menu = Factory.create(:price_list_menu)
    end

    it "should be able to create a section" do
      @section = @menu.price_list_sections.create :name => "Test"
      @section.id.should_not be_nil
      @section.position.should_not be_nil
    end
  end
end
