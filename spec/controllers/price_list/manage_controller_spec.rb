require  File.expand_path(File.dirname(__FILE__)) + "/../../price_list_spec_helper"

describe PriceList::ManageController do
  integrate_views
  
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
      expect {
        get :edit, :path => [@menu.id]
      }.to change{ PriceListSection.count }
      response.status.should == '200 OK'
    end
    
    describe "Section" do
      before(:each) do
        @default_section = @menu.price_list_sections.create :name => 'Default Section'
      end
      
      it "should add a new section to top" do
        expect {
          post :add_to_tree, :path => [@menu.id, @default_section.id], :position => 'top'
        }.to change{ PriceListSection.count }
        @new_section = PriceListSection.last
        @new_section.name.should == 'New Section'
        @new_section.position.should == 1
        @default_section.reload
        @default_section.position.should == 2
      end

      it "should add a new section to bottom" do
        expect {
          post :add_to_tree, :path => [@menu.id, @default_section.id], :position => 'bottom'
        }.to change{ PriceListSection.count }
        @new_section = PriceListSection.last
        @new_section.name.should == 'New Section'
        @new_section.position.should == 2
        @default_section.reload
        @default_section.position.should == 1
      end
      
      describe "Tree" do
        before(:each) do
          @section2 = Factory.create(:price_list_section, :price_list_menu => @menu)
          @section3 = Factory.create(:price_list_section, :price_list_menu => @menu)
          @section4 = Factory.create(:price_list_section, :price_list_menu => @menu)
        end
        
        it "should be able to move sections" do
          post :update_tree, :path => [@menu.id], :section_tree => {@section3.id => {}}
          @default_section.reload
          @section2.reload
          @section3.reload
          @section4.reload
          @section3.position.should == 1
          @default_section.position.should == 2
          @section2.position.should == 3
          @section4.position.should == 4
        end

        it "should be able to move sections" do
          post :update_tree, :path => [@menu.id], :section_tree => {@default_section.id => {:left_id => @section3.id}}
          @default_section.reload
          @section2.reload
          @section3.reload
          @section4.reload
          @section2.position.should == 1
          @section3.position.should == 2
          @section4.position.should == 3
          @default_section.position.should == 4
        end
        
        describe "Items" do
          before(:each) do
            @item1 = Factory.create(:price_list_item, :price_list_section => @default_section)
            @item2 = Factory.create(:price_list_item, :price_list_section => @default_section)
          end
          
          it "should render the section" do
            get :section, :path => [@menu.id, @default_section.id]
            response.status.should == '200 OK'
          end
          
          it "should update the section" do
            post :update_section, :path => [@menu.id, @default_section.id], :section => {:name => 'My New Section Name'}
            @default_section.reload
            @default_section.name.should == 'My New Section Name'
          end

          it "should create items for section" do
            expect {
              post :update_section, :path => [@menu.id, @section2.id], :section => {:items => {0 => {:name => 'My New Item Name'}}}
            }.to change{ PriceListItem.count }
            @section2.reload
            @section2.price_list_items.size.should == 1
            @section2.price_list_items[0].name.should == 'My New Item Name'
          end

          it "should update items for section" do
            @default_section.price_list_items[0].name.should == @item1.name
            @default_section.price_list_items[1].name.should == @item2.name
            expect {
              post :update_section, :path => [@menu.id, @default_section.id], :section => {:items => {1 => {:name => @item1.name, :position => 2}, 3 => {:name => 'My New Item Name', :position => 1}}}
            }.to change{ PriceListItem.count }.by(0)
            @default_section.reload
            @default_section.price_list_items.size.should == 2
            @default_section.price_list_items[0].name.should == 'My New Item Name'
            @default_section.price_list_items[1].name.should == @item1.name
          end
          
          it "should be able to delete a section" do
            expect {
              expect {
                post :delete_section, :path => [@menu.id, @default_section.id]
              }.to change{ PriceListSection.count }.by(-1)
            }.to change{ PriceListItem.count }.by(-2)
          end
          
          it "should be able to add new item" do
            post :new_item, :path => [@menu.id, @default_section.id], :item => {:name => 'My New Item Name'}
            response.status.should == '200 OK'
            response.body.should include('My New Item Name')
          end
        end
      end
    end
  end
end
