class PriceList::PageController < ParagraphController

  editor_header 'Price List Paragraphs'
  
  editor_for :view, :name => "View", :feature => :price_list_page_view

  class ViewOptions < HashModel
    attributes :price_list_menu_id => nil

    options_form(
                 fld(:price_list_menu_id, :select, :options => :price_list_menu_options)
                 )
    
    def price_list_menu_options
      PriceListMenu.select_options_with_nil
    end
    
    def price_list_menu
      @price_list_menu ||= PriceListMenu.find_by_id(self.price_list_menu_id)
    end
  end
end
