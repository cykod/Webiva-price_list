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
      @item.extra_prices.should == []
    end
    
    describe "Price Lists" do
      before(:each) do
        @item = Factory.create(:price_list_item, :price_list_section => @section)
      end
      
      it "should be able to store extra prices" do
        @item.extra_prices_list = "7::steak\r\n8::chicken\n\n5\n 2 :: lamb\n\n"
        @item.extra_prices.should == [{:price => '7', :name => 'steak'}, {:price => '8', :name => 'chicken'}, {:price => '5', :name => nil}, {:price => '2', :name => 'lamb'}]
        @item.extra_prices_models.size.should == 4
        @item.extra_prices_models[0].price.should == '7'
        @item.extra_prices_models[0].name.should == 'steak'
        @item.extra_prices_models[3].price.should == '2'
        @item.extra_prices_models[3].name.should == 'lamb'
        @item.save.should be_true
        
        @item = PriceListItem.find @item.id
        @item.extra_prices.should == [{:price => '7', :name => 'steak'}, {:price => '8', :name => 'chicken'}, {:price => '5', :name => nil}, {:price => '2', :name => 'lamb'}]
        @item.extra_prices_list.should == "7::steak\n8::chicken\n5\n2::lamb"
      end
    end
  end
end
