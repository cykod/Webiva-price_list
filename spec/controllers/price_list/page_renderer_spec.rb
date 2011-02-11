require  File.expand_path(File.dirname(__FILE__)) + "/../../price_list_spec_helper"

describe PriceList::PageRenderer, :type => :controller do
  controller_name :page
  integrate_views

  reset_domain_tables :domain_file, :price_list_menu, :price_list_section, :price_list_item

  describe "Page Render" do
    def generate_page_renderer(paragraph, options={}, inputs={})
      @rnd = build_renderer('/page', '/price_list/page/' + paragraph, options, inputs)
    end

    before(:each) do
      @menu = Factory.create(:price_list_menu)
      
      @section = Factory.create(:price_list_section, :price_list_menu => @menu)
      Factory.create(:price_list_item, :price_list_section => @section)

      @section = Factory.create(:price_list_section, :price_list_menu => @menu)
      Factory.create(:price_list_item, :price_list_section => @section)
    end

    it "should be able to view menu when menu is not set" do
      @rnd = generate_page_renderer('view')
      renderer_get @rnd
    end

    it "should be able to view menu" do
      @rnd = generate_page_renderer('view', :price_list_menu_id => @menu.id)
      PriceListMenu.should_receive(:find_by_id).with(@menu.id).and_return(@menu)
      renderer_get @rnd
    end
  end
end
