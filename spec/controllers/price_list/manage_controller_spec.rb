require  File.expand_path(File.dirname(__FILE__)) + "/../../price_list_spec_helper"

describe PriceList::ManageController do
  reset_domain_tables :domain_file, :price_list_menu, :price_list_section, :price_list_item

  before(:each) do
    mock_editor
  end
  
  it "should render the menu create page" do
    get :menu, :path => []
    response.status.should == '200 OK'
  end

  it "should create a new menu" do
    expect {
      post :menu, :path => [], :commit => true, :menu => {:name => 'Test Menu'}
    }.to change{ PriceListMenu.count }
    @menu = PriceListMenu.last
    @menu.name.should == 'Test Menu'
    response.should redirect_to(:action => 'edit', :path => @menu.id)
  end

  it "should not create a new menu" do
    expect {
      post :menu, :path => [], :menu => {:name => 'Test Menu'}
    }.to change{ PriceListMenu.count }.by(0)
    response.should redirect_to(:controller => '/content')
  end
  
  describe "Menu" do
    before(:each) do
      @menu = Factory.create(:price_list_menu)
    end

    it "should render the menu configure page" do
      get :menu, :path => [@menu.id]
      response.status.should == '200 OK'
    end

    it "should edit a new menu" do
      expect {
        post :menu, :path => [@menu.id], :commit => true, :menu => {:name => 'My New Test Menu'}
      }.to change{ PriceListMenu.count }.by(0)
      @menu.reload
      @menu.name.should == 'My New Test Menu'
      response.should redirect_to(:action => 'edit', :path => @menu.id)
    end

    it "should not edit a new menu" do
      expect {
        post :menu, :path => [@menu.id], :menu => {:name => 'My New Test Menu'}
      }.to change{ PriceListMenu.count }.by(0)
      response.should redirect_to(:action => 'edit', :path => @menu.id)
    end
  
    it "should render the menu edit page" do
      get :edit, :path => [@menu.id]
      response.status.should == '200 OK'
    end
  end
end
