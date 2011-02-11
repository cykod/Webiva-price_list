require  File.expand_path(File.dirname(__FILE__)) + "/../price_list_spec_helper"

describe PriceListItem do
  reset_domain_tables :price_list_menu, :price_list_section, :price_list_item

  it "should require a name and section" do
    @menu = PriceListItem.new
    @menu.should have(1).error_on(:name)
    @menu.should have(1).error_on(:price_list_section_id)
  end
  
  describe "Section" do
    before(:each) do
      @section = Factory.create(:price_list_section)
    end

    it "should be able to create a section" do
      @item = @section.price_list_items.create :name => "Test"
      @item.id.should_not be_nil
      @item.position.should_not be_nil
      @item.price_list_menu_id.should_not be_nil
    end
  end
end
