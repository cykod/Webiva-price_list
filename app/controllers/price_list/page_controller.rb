class PriceList::PageController < ParagraphController

  editor_header 'Price List Paragraphs'
  
  editor_for :view, :name => "View", :feature => :price_list_page_view

  class ViewOptions < HashModel
    # Paragraph Options
    # attributes :success_page_id => nil

    options_form(
                 # fld(:success_page_id, :page_selector) # <attribute>, <form element>, <options>
                 )
  end

end
