class PriceList::PageRenderer < ParagraphRenderer

  features '/price_list/page_feature'

  paragraph :view

  def view
    @options = paragraph_options :view

    # Any instance variables will be sent in the data hash to the 
    # price_list_page_view_feature automatically
  
    render_paragraph :feature => :price_list_page_view
  end

end
